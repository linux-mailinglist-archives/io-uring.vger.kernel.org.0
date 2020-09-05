Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39CE25E93C
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 19:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgIERMZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 13:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbgIERMX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 13:12:23 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8486C061244
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 10:12:15 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id k15so10466079wrn.10
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 10:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=1MJCTCwGsunEitBcwFkJy6yFK62CVklnJ72pbhEr/CM=;
        b=Q5v7kleveO6XezT38XR3lwzF5tja6VLeRkiqvHEdzG5XYaGwAGQDqZlAxX/eTX9H6v
         RvOyITzUcb5Qo+z17rB7eGYtR2Lyy7MZPFDY7AKDrkQ6BJoZaB/EVOoeaKgp8kUweo9D
         RHNypIbOZSjVqlc7h38YbjhTcD7XZiyqwJ+k+wL6POgh6PyvXGNPt2057wYD4d08HDOZ
         Q94I/de3G3P3IQ7AoQ1WeDK9JRB2uz1/2qDxC3yF3Ik7LfnYPWnnN3InMSahlI9mAliS
         XG2Ii/bvPG6YIpZLYeJJ/EQGtqO2eETlDuyDRNNVwEXTtqnmyNCLrcySrNmq1qDWSOzL
         eJVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=1MJCTCwGsunEitBcwFkJy6yFK62CVklnJ72pbhEr/CM=;
        b=ejxC7owm4I2caQP8yXICELhC3oFPpTuIaIzrK3Emnh2aBcFJKf2NHw+4w+NyF75Y9Z
         tikvZnjt55fUGxait7vYed51TBlUj+84gb9hAyptIALyuMBjmTd+Umg0Tj56dBktti96
         2sEtOfOHHTdVV3JzWQWSIqxGsYzWEj6SOLUzwHbvcl5HTCpTovnAb53HMSXkxtMbDvEE
         ms5QPOiuCXozo2Uv4v33FyvRZ9AhLiy/7Y5LrR3bzhHdvOylBGHL2WB9K1px8HpBRBtY
         CrLUwQmr9OplPOjXuUhZzqOCqEfQh6sN9kqTVyb/yutoDKiZjmSd8BUz3OMtayRycPEw
         b8tA==
X-Gm-Message-State: AOAM531ODhSTKsO7MDCYwFPE+Lj3N9eS2GcAJ2T27T8WkgYBU6LZhI7Q
        3cuYn1QcMmPJiqv7JOLGihSMLxdqYNAexA==
X-Google-Smtp-Source: ABdhPJwMLJ/rxoKzjE88pqZSm+Bx0uITI1olD08jaDX6oZzZdqjT17adhfuHYBXTUwq3y+0UifvQnw==
X-Received: by 2002:adf:df05:: with SMTP id y5mr14172201wrl.39.1599325932393;
        Sat, 05 Sep 2020 10:12:12 -0700 (PDT)
Received: from localhost.localdomain (ip-95-222-154-235.hsi15.unitymediagroup.de. [95.222.154.235])
        by smtp.gmail.com with ESMTPSA id t16sm18718474wrm.57.2020.09.05.10.12.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 10:12:11 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Norman Maurer <norman.maurer@googlemail.com>
Mime-Version: 1.0 (1.0)
Subject: Re: Support for shutdown
Date:   Sat, 5 Sep 2020 19:12:11 +0200
Message-Id: <C500A9A0-F9E1-427F-BCEC-04CB8D9F252E@googlemail.com>
References: <0b53b115-cb97-bb84-6419-9e6e6b5f251d@kernel.dk>
Cc:     io-uring@vger.kernel.org
In-Reply-To: <0b53b115-cb97-bb84-6419-9e6e6b5f251d@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: iPhone Mail (18A5369b)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Yes in 5.8 branch would be the easiest...

You rock!

Bye
Norman

> Am 05.09.2020 um 19:11 schrieb Jens Axboe <axboe@kernel.dk>:
>=20
> =EF=BB=BFOn 9/5/20 11:03 AM, Norman Maurer wrote:
>> Hi there,
>>=20
>> As you may have noticed from previous emails we are currently writing
>> a new transport for netty that will use io_uring under the hood for
>> max performance. One thing that is missing at the moment is the
>> support for =E2=80=9Cshutdown=E2=80=9D. Shutdown is quite useful in TCP l=
and when you
>> only want to close either input or output of the connection.
>>=20
>> Is this something you think that can be added in the future ? This
>> would be a perfect addition to the already existing close support.
>=20
> Something like this should do it, should just be split into having the
> net part as a prep patch. I can add this to the 5.8 branch if that's
> easier for you to test?
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index a9a625ceea5f..67714078e85d 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -529,6 +529,11 @@ struct io_statx {
>    struct statx __user        *buffer;
> };
>=20
> +struct io_shutdown {
> +    struct file            *file;
> +    int                how;
> +};
> +
> struct io_completion {
>    struct file            *file;
>    struct list_head        list;
> @@ -666,6 +671,7 @@ struct io_kiocb {
>        struct io_splice    splice;
>        struct io_provide_buf    pbuf;
>        struct io_statx        statx;
> +        struct io_shutdown    shutdown;
>        /* use only after cleaning per-op data, see io_clean_op() */
>        struct io_completion    compl;
>    };
> @@ -922,6 +928,9 @@ static const struct io_op_def io_op_defs[] __read_most=
ly =3D {
>        .hash_reg_file        =3D 1,
>        .unbound_nonreg_file    =3D 1,
>    },
> +    [IORING_OP_SHUTDOWN] =3D {
> +        .needs_file        =3D 1,
> +    },
> };
>=20
> enum io_mem_account {
> @@ -3367,6 +3376,44 @@ static int io_write(struct io_kiocb *req, bool forc=
e_nonblock,
>    return ret;
> }
>=20
> +static int io_shutdown_prep(struct io_kiocb *req,
> +                const struct io_uring_sqe *sqe)
> +{
> +#if defined(CONFIG_NET)
> +    if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPO=
LL)))
> +        return -EINVAL;
> +    if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
> +        sqe->rw_flags || sqe->buf_index)
> +        return -EINVAL;
> +
> +    req->shutdown.how =3D READ_ONCE(sqe->len);
> +    return 0;
> +#else
> +    return -EOPNOTSUPP;
> +#endif
> +}
> +
> +static int io_shutdown(struct io_kiocb *req, bool force_nonblock)
> +{
> +#if defined(CONFIG_NET)
> +    struct socket *sock;
> +    int ret;
> +
> +    if (force_nonblock)
> +        return -EAGAIN;
> +
> +    sock =3D sock_from_file(req->file, &ret);
> +    if (unlikely(!sock))
> +        return ret;
> +
> +    ret =3D __sys_shutdown_sock(sock, req->shutdown.how);
> +    io_req_complete(req, ret);
> +    return 0;
> +#else
> +    return -EOPNOTSUPP;
> +#endif
> +}
> +
> static int __io_splice_prep(struct io_kiocb *req,
>                const struct io_uring_sqe *sqe)
> {
> @@ -5588,6 +5635,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
>    case IORING_OP_TEE:
>        ret =3D io_tee_prep(req, sqe);
>        break;
> +    case IORING_OP_SHUTDOWN:
> +        ret =3D io_shutdown_prep(req, sqe);
> +        break;
>    default:
>        printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
>                req->opcode);
> @@ -5942,6 +5992,14 @@ static int io_issue_sqe(struct io_kiocb *req, const=
 struct io_uring_sqe *sqe,
>        }
>        ret =3D io_tee(req, force_nonblock);
>        break;
> +    case IORING_OP_SHUTDOWN:
> +        if (req) {
> +            ret =3D io_shutdown_prep(req, sqe);
> +            if (ret < 0)
> +                break;
> +        }
> +        ret =3D io_shutdown(req, force_nonblock);
> +        break;
>    default:
>        ret =3D -EINVAL;
>        break;
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index e9cb30d8cbfb..385894b4a8bb 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -436,6 +436,7 @@ extern int __sys_getpeername(int fd, struct sockaddr _=
_user *usockaddr,
>                 int __user *usockaddr_len);
> extern int __sys_socketpair(int family, int type, int protocol,
>                int __user *usockvec);
> +extern int __sys_shutdown_sock(struct socket *sock, int how);
> extern int __sys_shutdown(int fd, int how);
>=20
> extern struct ns_common *get_net_ns(struct ns_common *ns);
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h=

> index 7539d912690b..2301c37e86cb 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -132,6 +132,7 @@ enum {
>    IORING_OP_PROVIDE_BUFFERS,
>    IORING_OP_REMOVE_BUFFERS,
>    IORING_OP_TEE,
> +    IORING_OP_SHUTDOWN,
>=20
>    /* this goes last, obviously */
>    IORING_OP_LAST,
> diff --git a/net/socket.c b/net/socket.c
> index 0c0144604f81..8616962c27bc 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2192,6 +2192,17 @@ SYSCALL_DEFINE5(getsockopt, int, fd, int, level, in=
t, optname,
>  *    Shutdown a socket.
>  */
>=20
> +int __sys_shutdown_sock(struct socket *sock, int how)
> +{
> +    int err;
> +
> +    err =3D security_socket_shutdown(sock, how);
> +    if (!err)
> +        err =3D sock->ops->shutdown(sock, how);
> +
> +    return err;
> +}
> +
> int __sys_shutdown(int fd, int how)
> {
>    int err, fput_needed;
> @@ -2199,9 +2210,7 @@ int __sys_shutdown(int fd, int how)
>=20
>    sock =3D sockfd_lookup_light(fd, &err, &fput_needed);
>    if (sock !=3D NULL) {
> -        err =3D security_socket_shutdown(sock, how);
> -        if (!err)
> -            err =3D sock->ops->shutdown(sock, how);
> +        err =3D __sys_shutdown_sock(sock, how);
>        fput_light(sock->file, fput_needed);
>    }
>    return err;
>=20
> --=20
> Jens Axboe
>=20
