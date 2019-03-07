defmodule Stripe.PaymentIntent do
  @moduledoc """
  Work with Stripe payment intents.

  Stripe API reference: https://stripe.com/docs/api/payment_intents
  """

  use Stripe.Entity
  import Stripe.Request

  @type transfer_data :: %{
          :destination => String.t()
        }

  @type capture_method :: :automatic | :manual

  @type create_params :: %{
          :amount => String.t(),
          :payment_method_types => list(String.t()),
          :currency => String.t()
        }

  @type t :: %__MODULE__{
          id: Stripe.id(),
          object: String.t(),
          amount: integer | nil,
          amount_capturable: integer | nil,
          amount_received: integer | nil,
          canceled_at: Stripe.timestamp(),
          capture_method: capture_method,
          charges: Stripe.List.t(Stripe.Charge.t()),
          client_secret: String.t() | nil,
          confirmation_method: String.t() | nil,
          created: Stripe.timestamp(),
          currency: String.t() | nil,
          customer: Stripe.id() | Stripe.Customer.t(),
          description: String.t() | nil,
          last_payment_error: String.t() | nil,
          livemode: boolean,
          metadata: Stripe.Types.metadata(),
          next_action: String.t() | nil,
          on_behalf_of: String.t() | nil,
          payment_method_types: list(String.t()),
          receipt_email: String.t() | nil,
          review: Stripe.id() | Stripe.Review.t() | nil,
          shipping: Stripe.Types.shipping() | nil,
          source: Stripe.id() | Stripe.Source.t() | nil,
          statement_descriptor: String.t() | nil,
          status: String.t(),
          transfer_data: transfer_data,
          transfer_group: String.t() | nil
        }

  defstruct [
    :id,
    :object,
    :amount,
    :amount_capturable,
    :amount_received,
    :canceled_at,
    :capture_method,
    :charges,
    :client_secret,
    :confirmation_method,
    :created,
    :currency,
    :customer,
    :description,
    :last_payment_error,
    :livemode,
    :metadata,
    :next_action,
    :on_behalf_of,
    :payment_method_types,
    :receipt_email,
    :review,
    :shipping,
    :source,
    :statement_descriptor,
    :status,
    :transfer_data,
    :transfer_group
  ]

  @plural_endpoint "payment_intents"

  @doc """
  Create a payment intent.
  """
  @spec create(create_params, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
  def create(params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end

  @doc """
  Confirm a payment intent.
  """
  @spec confirm(Stripe.id() | t, params, Stripe.options()) ::
          {:ok, t} | {:error, Stripe.Error.t()}
        when params: %{
               optional(:source) => String.t()
             }
  def confirm(id, %{} = params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}/confirm")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  Capture a payment intent.
  """
  @spec capture(Stripe.id() | t, params, Stripe.options()) ::
          {:ok, t} | {:error, Stripe.Error.t()}
        when params: %{
          optional(:amount_to_capture) => integer,
          optional(:application_fee_amount) => integer
        }
  def capture(id, %{} = params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}/capture")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  Cancel a payment intent.
  """
  @spec cancel(Stripe.id() | t, params, Stripe.options()) ::
          {:ok, t} | {:error, Stripe.Error.t()}
        when params: %{
          optional(:cancellation_reason) => String.t,
        }
  def cancel(id, %{} = params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}/cancel")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  Retrieve a payment intent.
  """
  @spec retrieve(Stripe.id() | t, params, Stripe.options()) ::
          {:ok, t} | {:error, Stripe.Error.t()}
        when params: %{
               optional(:client_secret) => String.t()
             }
  def retrieve(id, %{} = params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  List payment intents.
  """
  @spec list(params, Stripe.options()) :: {:ok, Stripe.List.t(t)} | {:error, Stripe.Error.t()}
        when params: %{
               optional(:ending_before) => t | Stripe.id(),
               optional(:limit) => 1..100,
               optional(:starting_after) => t | Stripe.id()
             }
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  Update a payment intent.

  Takes the `id` and a map of changes
  """
  @spec update(Stripe.id() | t, params, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
        when params: %{
               optional(:metadata) => Stripe.Types.metadata()
             }
  def update(id, %{} = params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end
end
