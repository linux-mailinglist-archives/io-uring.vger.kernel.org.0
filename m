Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0DB7159A77
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 21:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731804AbgBKUXV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 15:23:21 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38916 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731812AbgBKUXU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 15:23:20 -0500
Received: by mail-wr1-f68.google.com with SMTP id y11so14158559wrt.6
        for <io-uring@vger.kernel.org>; Tue, 11 Feb 2020 12:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=/RxGX6ZYCvrn1ewamJBdvUnbdq7zMeTp/xBlSklFgsc=;
        b=dh8mIa2erBiA8nOHgPFbH+phIFW/sBtTRadbYxeI6spjvcdoHRvberSkoN88oxYFJF
         I8Bl7Jjd2vJgs1+e6dkn6rGjWYJ0J++APl/wHR45TRS/xhNfKLHsgdFL4bDHTjZZ8jLZ
         5gv3HlvpLD3/pL3AGMVbga2zndbQKm66BsiEmfqaVvrnxewVgrxXYY2PEmArLpmMsLfn
         V5oI1avG7rYW5eA+pVq7zwLrp8fL/iz7Xj9qbE5TnqZfZ4tlftG9PMHSoqlyIvF4mMCw
         jXgw0up8iA8IrvffQD2eO41c6QpW+UUklRBPWN98yEAkZKxVkeSaPJjcMpMPAK0PA7Df
         +rUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=/RxGX6ZYCvrn1ewamJBdvUnbdq7zMeTp/xBlSklFgsc=;
        b=clX/T34CRlUQ7L9Hk3jPN3uZ4G6HBgYY1LlteuOMauMgNnN+hP62xqUMOyhUQC88wB
         BLyjPQXYzUMfpUfBOYcMqL553ycWneFQ5InhxP2eNQ9oEf/eK8qbW+GzgUkChuDNWndJ
         AESNfqKvs24rpsF8LwaZ98SLZ+30UCW9MstRmn5bLVG/Qe4y4YM7DDKpHvnaiQalhHT5
         4f6fBTOTzPA+8088GPqayLHfuMiDP3YZONEb1Wod07EYBdEbBK6PMbGa+S/QQSrMGOCn
         LRgL/WSrN/rbV/aPTfrcXExg5O6eYuvgcinlJ9H0G0U0AA4Lbc80Ssl0jy8Q/6JMq+mD
         uiXg==
X-Gm-Message-State: APjAAAUfyn52asD9Efg4K595rBSCMMwObuQmY/twOJjx2pgJohReQNJ5
        i9I32CTmIifRHNgmia4oXkNzM6iU
X-Google-Smtp-Source: APXvYqzzdBYV5Pb75P16bEhgZbCDCpD9GZygKR5dtkbDC1+7vdT9ig2gOv1MNy6/IfkmZWQTer0JpA==
X-Received: by 2002:adf:f80b:: with SMTP id s11mr10911275wrp.12.1581452597689;
        Tue, 11 Feb 2020 12:23:17 -0800 (PST)
Received: from [192.168.43.18] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id a9sm6700561wrn.3.2020.02.11.12.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 12:23:17 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: allow POLL_ADD with double poll_wait()
 users
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20200210205650.14361-1-axboe@kernel.dk>
 <20200210205650.14361-4-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 mQINBFmKBOQBEAC76ZFxLAKpDw0bKQ8CEiYJRGn8MHTUhURL02/7n1t0HkKQx2K1fCXClbps
 bdwSHrhOWdW61pmfMbDYbTj6ZvGRvhoLWfGkzujB2wjNcbNTXIoOzJEGISHaPf6E2IQx1ik9
 6uqVkK1OMb7qRvKH0i7HYP4WJzYbEWVyLiAxUj611mC9tgd73oqZ2pLYzGTqF2j6a/obaqha
 +hXuWTvpDQXqcOZJXIW43atprH03G1tQs7VwR21Q1eq6Yvy2ESLdc38EqCszBfQRMmKy+cfp
 W3U9Mb1w0L680pXrONcnlDBCN7/sghGeMHjGKfNANjPc+0hzz3rApPxpoE7HC1uRiwC4et83
 CKnncH1l7zgeBT9Oa3qEiBlaa1ZCBqrA4dY+z5fWJYjMpwI1SNp37RtF8fKXbKQg+JuUjAa9
 Y6oXeyEvDHMyJYMcinl6xCqCBAXPHnHmawkMMgjr3BBRzODmMr+CPVvnYe7BFYfoajzqzq+h
 EyXSl3aBf0IDPTqSUrhbmjj5OEOYgRW5p+mdYtY1cXeK8copmd+fd/eTkghok5li58AojCba
 jRjp7zVOLOjDlpxxiKhuFmpV4yWNh5JJaTbwCRSd04sCcDNlJj+TehTr+o1QiORzc2t+N5iJ
 NbILft19Izdn8U39T5oWiynqa1qCLgbuFtnYx1HlUq/HvAm+kwARAQABtDFQYXZlbCBCZWd1
 bmtvdiAoc2lsZW5jZSkgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+iQJOBBMBCAA4FiEE+6Ju
 PTjTbx479o3OWt5b1Glr+6UFAlmKBOQCGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ
 Wt5b1Glr+6WxZA//QueaKHzgdnOikJ7NA/Vq8FmhRlwgtP0+E+w93kL+ZGLzS/cUCIjn2f4Q
 Mcutj2Neg0CcYPX3b2nJiKr5Vn0rjJ/suiaOa1h1KzyNTOmxnsqE5fmxOf6C6x+NKE18I5Jy
 xzLQoktbdDVA7JfB1itt6iWSNoOTVcvFyvfe5ggy6FSCcP+m1RlR58XxVLH+qlAvxxOeEr/e
 aQfUzrs7gqdSd9zQGEZo0jtuBiB7k98t9y0oC9Jz0PJdvaj1NZUgtXG9pEtww3LdeXP/TkFl
 HBSxVflzeoFaj4UAuy8+uve7ya/ECNCc8kk0VYaEjoVrzJcYdKP583iRhOLlZA6HEmn/+Gh9
 4orG67HNiJlbFiW3whxGizWsrtFNLsSP1YrEReYk9j1SoUHHzsu+ZtNfKuHIhK0sU07G1OPN
 2rDLlzUWR9Jc22INAkhVHOogOcc5ajMGhgWcBJMLCoi219HlX69LIDu3Y34uIg9QPZIC2jwr
 24W0kxmK6avJr7+n4o8m6sOJvhlumSp5TSNhRiKvAHB1I2JB8Q1yZCIPzx+w1ALxuoWiCdwV
 M/azguU42R17IuBzK0S3hPjXpEi2sK/k4pEPnHVUv9Cu09HCNnd6BRfFGjo8M9kZvw360gC1
 reeMdqGjwQ68o9x0R7NBRrtUOh48TDLXCANAg97wjPoy37dQE7e5Ag0EWYoE5AEQAMWS+aBV
 IJtCjwtfCOV98NamFpDEjBMrCAfLm7wZlmXy5I6o7nzzCxEw06P2rhzp1hIqkaab1kHySU7g
 dkpjmQ7Jjlrf6KdMP87mC/Hx4+zgVCkTQCKkIxNE76Ff3O9uTvkWCspSh9J0qPYyCaVta2D1
 Sq5HZ8WFcap71iVO1f2/FEHKJNz/YTSOS/W7dxJdXl2eoj3gYX2UZNfoaVv8OXKaWslZlgqN
 jSg9wsTv1K73AnQKt4fFhscN9YFxhtgD/SQuOldE5Ws4UlJoaFX/yCoJL3ky2kC0WFngzwRF
 Yo6u/KON/o28yyP+alYRMBrN0Dm60FuVSIFafSqXoJTIjSZ6olbEoT0u17Rag8BxnxryMrgR
 dkccq272MaSS0eOC9K2rtvxzddohRFPcy/8bkX+t2iukTDz75KSTKO+chce62Xxdg62dpkZX
 xK+HeDCZ7gRNZvAbDETr6XI63hPKi891GeZqvqQVYR8e+V2725w+H1iv3THiB1tx4L2bXZDI
 DtMKQ5D2RvCHNdPNcZeldEoJwKoA60yg6tuUquvsLvfCwtrmVI2rL2djYxRfGNmFMrUDN1Xq
 F3xozA91q3iZd9OYi9G+M/OA01husBdcIzj1hu0aL+MGg4Gqk6XwjoSxVd4YT41kTU7Kk+/I
 5/Nf+i88ULt6HanBYcY/+Daeo/XFABEBAAGJAjYEGAEIACAWIQT7om49ONNvHjv2jc5a3lvU
 aWv7pQUCWYoE5AIbDAAKCRBa3lvUaWv7pfmcEACKTRQ28b1y5ztKuLdLr79+T+LwZKHjX++P
 4wKjEOECCcB6KCv3hP+J2GCXDOPZvdg/ZYZafqP68Yy8AZqkfa4qPYHmIdpODtRzZSL48kM8
 LRzV8Rl7J3ItvzdBRxf4T/Zseu5U6ELiQdCUkPGsJcPIJkgPjO2ROG/ZtYa9DvnShNWPlp+R
 uPwPccEQPWO/NP4fJl2zwC6byjljZhW5kxYswGMLBwb5cDUZAisIukyAa8Xshdan6C2RZcNs
 rB3L7vsg/R8UCehxOH0C+NypG2GqjVejNZsc7bgV49EOVltS+GmGyY+moIzxsuLmT93rqyII
 5rSbbcTLe6KBYcs24XEoo49Zm9oDA3jYvNpeYD8rDcnNbuZh9kTgBwFN41JHOPv0W2FEEWqe
 JsCwQdcOQ56rtezdCJUYmRAt3BsfjN3Jn3N6rpodi4Dkdli8HylM5iq4ooeb5VkQ7UZxbCWt
 UVMKkOCdFhutRmYp0mbv2e87IK4erwNHQRkHUkzbsuym8RVpAZbLzLPIYK/J3RTErL6Z99N2
 m3J6pjwSJY/zNwuFPs9zGEnRO4g0BUbwGdbuvDzaq6/3OJLKohr5eLXNU3JkT+3HezydWm3W
 OPhauth7W0db74Qd49HXK0xe/aPrK+Cp+kU1HRactyNtF8jZQbhMCC8vMGukZtWaAwpjWiiH bA==
Message-ID: <1fb14ecd-4a2b-2eaa-97a5-d96a1fcc6aee@gmail.com>
Date:   Tue, 11 Feb 2020 23:22:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200210205650.14361-4-axboe@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KuqLqIaerrV2eH8xVd0UkKZ8hXXPoPoMO"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KuqLqIaerrV2eH8xVd0UkKZ8hXXPoPoMO
Content-Type: multipart/mixed; boundary="X4P8R2vkehzspcUOTnGiwnnIwhp823SOB";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Message-ID: <1fb14ecd-4a2b-2eaa-97a5-d96a1fcc6aee@gmail.com>
Subject: Re: [PATCH 3/3] io_uring: allow POLL_ADD with double poll_wait()
 users
References: <20200210205650.14361-1-axboe@kernel.dk>
 <20200210205650.14361-4-axboe@kernel.dk>
In-Reply-To: <20200210205650.14361-4-axboe@kernel.dk>

--X4P8R2vkehzspcUOTnGiwnnIwhp823SOB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/02/2020 23:56, Jens Axboe wrote:
> Some file descriptors use separate waitqueues for their f_ops->poll()
> handler, most commonly one for read and one for write. The io_uring
> poll implementation doesn't work with that, as the 2nd poll_wait()
> call will cause the io_uring poll request to -EINVAL.
>=20
> This is particularly a problem now that pipes were switched to using
> multiple wait queues (commit 0ddad21d3e99), but it also affects tty
> devices and /dev/random as well. This is a big problem for event loops
> where some file descriptors work, and others don't.
>=20
> With this fix, io_uring handles multiple waitqueues.
>=20
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++----=

>  1 file changed, 70 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 123e6424a050..72bc378edebc 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3439,10 +3439,27 @@ static int io_connect(struct io_kiocb *req, str=
uct io_kiocb **nxt,
>  #endif
>  }
> =20
> +static void io_poll_remove_double(struct io_kiocb *req)
> +{
> +	struct io_poll_iocb *poll =3D (struct io_poll_iocb *) req->io;
> +
> +	if (poll && poll->head) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&poll->head->lock, flags);
> +		list_del_init(&poll->wait.entry);
> +		if (poll->wait.private)
> +			refcount_dec(&req->refs);
> +		spin_unlock_irqrestore(&poll->head->lock, flags);
> +	}
> +}
> +
>  static void io_poll_remove_one(struct io_kiocb *req)
>  {
>  	struct io_poll_iocb *poll =3D &req->poll;
> =20
> +	io_poll_remove_double(req);
> +
>  	spin_lock(&poll->head->lock);
>  	WRITE_ONCE(poll->canceled, true);
>  	if (!list_empty(&poll->wait.entry)) {
> @@ -3678,10 +3695,39 @@ static int io_poll_wake(struct wait_queue_entry=
 *wait, unsigned mode, int sync,
>  	if (mask && !(mask & poll->events))
>  		return 0;
> =20
> +	io_poll_remove_double(req);
>  	__io_poll_wake(req, &req->poll, mask);
>  	return 1;
>  }
> =20
> +static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned=
 mode,
> +			       int sync, void *key)
> +{
> +	struct io_kiocb *req =3D wait->private;
> +	struct io_poll_iocb *poll =3D (void *) req->io;
> +	__poll_t mask =3D key_to_poll(key);
> +	bool done =3D true;
> +	int ret;
> +
> +	/* for instances that support it check for an event match first: */
> +	if (mask && !(mask & poll->events))
> +		return 0;
> +
> +	if (req->poll.head) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&req->poll.head->lock, flags);
> +		done =3D list_empty(&req->poll.wait.entry);
> +		if (!done)
> +			list_del_init(&req->poll.wait.entry);
> +		spin_unlock_irqrestore(&req->poll.head->lock, flags);
> +	}
> +	if (!done)
> +		__io_poll_wake(req, poll, mask);
> +	refcount_dec(&req->refs);
> +	return ret;
> +}
> +
>  struct io_poll_table {
>  	struct poll_table_struct pt;
>  	struct io_kiocb *req;
> @@ -3692,15 +3738,33 @@ static void io_poll_queue_proc(struct file *fil=
e, struct wait_queue_head *head,
>  			       struct poll_table_struct *p)
>  {
>  	struct io_poll_table *pt =3D container_of(p, struct io_poll_table, pt=
);
> +	struct io_kiocb *req =3D pt->req;
> +	struct io_poll_iocb *poll =3D &req->poll;
> =20
> -	if (unlikely(pt->req->poll.head)) {
> -		pt->error =3D -EINVAL;
> -		return;
> +	/*
> +	 * If poll->head is already set, it's because the file being polled
> +	 * use multiple waitqueues for poll handling (eg one for read, one
> +	 * for write). Setup a separate io_poll_iocb if this happens.
> +	 */
> +	if (unlikely(poll->head)) {

I'll keep looking, but I guess there should be :

if (req->io)
	return -EINVAL;

> +		poll =3D kmalloc(sizeof(*poll), GFP_ATOMIC);
> +		if (!poll) {
> +			pt->error =3D -ENOMEM;
> +			return;
> +		}
> +		poll->done =3D false;
> +		poll->canceled =3D false;
> +		poll->events =3D req->poll.events;
> +		INIT_LIST_HEAD(&poll->wait.entry);
> +		init_waitqueue_func_entry(&poll->wait, io_poll_double_wake);
> +		refcount_inc(&req->refs);
> +		poll->wait.private =3D req;
> +		req->io =3D (void *) poll;
>  	}
> =20
>  	pt->error =3D 0;
> -	pt->req->poll.head =3D head;
> -	add_wait_queue(head, &pt->req->poll.wait);
> +	poll->head =3D head;
> +	add_wait_queue(head, &poll->wait);
>  }
> =20
>  static void io_poll_req_insert(struct io_kiocb *req)
> @@ -3777,6 +3841,7 @@ static int io_poll_add(struct io_kiocb *req, stru=
ct io_kiocb **nxt)
>  	}
>  	if (mask) { /* no async, we'd stolen it */
>  		ipt.error =3D 0;
> +		io_poll_remove_double(req);
>  		io_poll_complete(req, mask, 0);
>  	}
>  	spin_unlock_irq(&ctx->completion_lock);
>=20

--=20
Pavel Begunkov


--X4P8R2vkehzspcUOTnGiwnnIwhp823SOB--

--KuqLqIaerrV2eH8xVd0UkKZ8hXXPoPoMO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5DDQ4ACgkQWt5b1Glr
+6VtSg/9Es4HDjjljStcWXfyK462ZCV6WzLkjC1QH8OzDWh/ZQOfFJ4kIEQhJtd+
I/S39iimgG8fDiSaVx1oyQEMOkzwQyp4U3CXDGrCK/yLmXvZEf4fwW/inJ0NX30B
b/gVQ/8YslmeBSJjxzq23FlX27pNuR/0NGhBYNWUMtkOEU/7Bzwl8wuysECfr4FD
qWDnAd3ieC9EQ4wlaziHsNOUNK90TpfrP7B3JkKVDl7P6lwdFecz4a8b0XUffC5Z
zgXLFw2RI1jermpTnkNjHOWUfDVNFyd4693Liyix7FXeCC22Dupf5c2WiicD2kZk
9j324NpugGwIYfdFbvHJSQX2pnQCKJHOL2OdAtdg4B3L4KgAIP2azMnaHK05H2XQ
+SPfn6T/DORVW/EmOToW0zF7UDI5EMEvKp3JQL/G2ZOlPgypoANsgFBeahjd63lY
iPZJWpZ5g7XeTTjhwiS5yBYRmYUBfFgh1D5dUmorOfBx46ala7RTtzIWSj1Xwu1W
Udibqo94itpjVhWtODrIfw1ZGXcFHkm/eR6OwYTOuBLTUxCBi7ivKQZEpJmpjSBJ
VJZBB84tljqe8McPQCdEvDNSizsoKsUBau5GIE47r/azAZ+beQezQqVFarUgTRp/
demMOby7woLKDQWYHGBUsg1IGACGnekFhMXmOOQvcWws8KtiEDc=
=ZXVI
-----END PGP SIGNATURE-----

--KuqLqIaerrV2eH8xVd0UkKZ8hXXPoPoMO--
