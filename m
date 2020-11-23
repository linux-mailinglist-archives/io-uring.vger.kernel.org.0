Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54F22C0F1B
	for <lists+io-uring@lfdr.de>; Mon, 23 Nov 2020 16:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbgKWPkX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Nov 2020 10:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729393AbgKWPkW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Nov 2020 10:40:22 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68CDC0613CF
        for <io-uring@vger.kernel.org>; Mon, 23 Nov 2020 07:40:20 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id cq7so17556080edb.4
        for <io-uring@vger.kernel.org>; Mon, 23 Nov 2020 07:40:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=UzqrESNUq1EbMrGF6xvcj7QUtogJ2eIriZzk46N7Rhw=;
        b=ENvk6+lCgDdV8Dd5SxatKZ7mO2P84KEvKDlySEBs2J5WVIJsongMCeA0NWdS6I+g+g
         sDOVGzCqMg+lU+cAw0/ustKebEGs6h5AR4kLDCI9ZtpWzI2Z+/XAv9U9Q/YjYa0OpDbS
         ZoYA3fcAZM/hS05JKdK8WhzCnBSFXEIugRe7oFp6lFfmSgGsUqtjj78IRk+QtMyauHIu
         2N+mxOVPsc3Ml7SLkaBHDGr1Jq1QQifvuW48qdX/yK8xZKsnU4KM6mor8VGPWKz3Ec/T
         UMuDxkmsjlRPOJBv60CDD17RVXvc/TW6H+Q2yt6FohNqiPXE8UJfAue9seao7N9mcyXB
         tvAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=UzqrESNUq1EbMrGF6xvcj7QUtogJ2eIriZzk46N7Rhw=;
        b=AGaAGsspZUtHjJlRlVluQURlnsTq4ESudretjbJDo+RH6eKTGOS6ZvqpUnYj83ssWP
         504DdkSPIjy9td7N++10apAYiH3DDgkSWh7ShLFis5lnJ6wSYdCm10kmGEcxZnezw78z
         jzI8aoUS0HpKDXl7h3+1k+qsi3I4H6Lv9ndda64NzAYV0eOwAlPlxCLcZBmN9Lb5uXVa
         kSfEnuDzD0Inw67a4na8+hbhKbqE8t/eUjIN4WmkTEdpXYUyC+Wb9fgBZP10Avmm0PCC
         kTUjgbcZUh8Fu4G+oicH32yl+1TlAwW0RcpkoPF5l4/E0eUOeGZIHIMzpFa8OeFUc2Mv
         lEfQ==
X-Gm-Message-State: AOAM530X3PQIPNpEC53sYiGmW/UQbRbIRMVInDng2NLpVQ1769ZR/uaG
        GtPl5nMtDuyZiZXlopXrVmyAd05xvJyY2bJlRWgdr3VSCgokDXQc
X-Google-Smtp-Source: ABdhPJyDLRnEePz9HcBXfyhzdJg4QcM0aVhBrpT8CsU51VvgvM8QX0oJZVCQm3h6luT/KWFzUSUSxNmECR2b8ZjLPh8=
X-Received: by 2002:a50:f157:: with SMTP id z23mr15085746edl.303.1606146019110;
 Mon, 23 Nov 2020 07:40:19 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwjmGd8=992NjY6TjgsbMoxFS5j2_71bgaYUOUT0vG-19A@mail.gmail.com>
In-Reply-To: <CAM1kxwjmGd8=992NjY6TjgsbMoxFS5j2_71bgaYUOUT0vG-19A@mail.gmail.com>
From:   Victor Stewart <v@nametag.social>
Date:   Mon, 23 Nov 2020 15:40:08 +0000
Message-ID: <CAM1kxwjLFfXDHSTgJWU8wXueSqtwF3XtSmaumaHfvgvq0dLpkQ@mail.gmail.com>
Subject: Re: [RFC 1/1] whitelisting UDP GSO and GRO cmsgs
To:     io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

sorry there was a typo "msr" instead of "msg"

diff --git a/net/socket.c b/net/socket.c
index 6e6cccc2104f..31ebd0440e30 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2416,9 +2416,9 @@ static int ___sys_sendmsg(struct socket *sock,
struct user_msghdr __user *msg,
 long __sys_sendmsg_sock(struct socket *sock, struct msghdr *msg,
                        unsigned int flags)
 {
-       /* disallow ancillary data requests from this path */
        if (msg->msg_control || msg->msg_controllen)
-               return -EINVAL;
+               if (!__sys_whitelisted_cmsghdrs(msg))
+                       return -EINVAL;

        return ____sys_sendmsg(sock, msg, flags, NULL, 0);
 }
@@ -2620,6 +2620,15 @@ static int ___sys_recvmsg(struct socket *sock,
struct user_msghdr __user *msg,
        return err;
 }

+static bool __sys_whitelisted_cmsghdrs(struct msghdr *msg)
+{
+       for (struct cmsghdr *cmsg = CMSG_FIRSTHDR(msg); cmsg != NULL;
cmsg = CMSG_NXTHDR(message, cmsg))
+               if (cmsg->cmsg_level != SOL_UDP || (cmsg->cmsg_type !=
UDP_GRO && cmsg->cmsg_type != UDP_SEGMENT))
+                       return false;
+
+       return true;
+}
+
 /*
  *     BSD recvmsg interface
  */
@@ -2630,7 +2639,7 @@ long __sys_recvmsg_sock(struct socket *sock,
struct msghdr *msg,
 {
        if (msg->msg_control || msg->msg_controllen) {
                /* disallow ancillary data reqs unless cmsg is plain data */
-               if (!(sock->ops->flags & PROTO_CMSG_DATA_ONLY))
+               if (!( sock->ops->flags & PROTO_CMSG_DATA_ONLY ||
__sys_whitelisted_cmsghdrs(msg) ))
                        return -EINVAL;
        }

On Mon, Nov 23, 2020 at 3:35 PM Victor Stewart <v@nametag.social> wrote:
>
> add __sys_whitelisted_cmsghdrs() and configure __sys_recvmsg_sock and
> __sys_sendmsg_sock to use it.
>
> Signed-off by: Victor Stewart <v@nametag.social>
> ---
>  net/socket.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/net/socket.c b/net/socket.c
> index 6e6cccc2104f..44e28bb08bbe 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2416,9 +2416,9 @@ static int ___sys_sendmsg(struct socket *sock,
> struct user_msghdr __user *msg,
>  long __sys_sendmsg_sock(struct socket *sock, struct msghdr *msg,
>                         unsigned int flags)
>  {
> -       /* disallow ancillary data requests from this path */
>         if (msg->msg_control || msg->msg_controllen)
> -               return -EINVAL;
> +               if (!__sys_whitelisted_cmsghdrs(msr))
> +                       return -EINVAL;
>
>         return ____sys_sendmsg(sock, msg, flags, NULL, 0);
>  }
> @@ -2620,6 +2620,15 @@ static int ___sys_recvmsg(struct socket *sock,
> struct user_msghdr __user *msg,
>         return err;
>  }
>
> +static bool __sys_whitelisted_cmsghdrs(struct msghdr *msg)
> +{
> +       for (struct cmsghdr *cmsg = CMSG_FIRSTHDR(msg); cmsg != NULL;
> cmsg = CMSG_NXTHDR(message, cmsg))
> +               if (cmsg->cmsg_level != SOL_UDP || (cmsg->cmsg_type !=
> UDP_GRO && cmsg->cmsg_type != UDP_SEGMENT))
> +                       return false;
> +
> +       return true;
> +}
> +
>  /*
>   *     BSD recvmsg interface
>   */
> @@ -2630,7 +2639,7 @@ long __sys_recvmsg_sock(struct socket *sock,
> struct msghdr *msg,
>  {
>         if (msg->msg_control || msg->msg_controllen) {
>                 /* disallow ancillary data reqs unless cmsg is plain data */
> -               if (!(sock->ops->flags & PROTO_CMSG_DATA_ONLY))
> +               if (!( sock->ops->flags & PROTO_CMSG_DATA_ONLY ||
> __sys_whitelisted_cmsghdrs(msr) ))
>                         return -EINVAL;
>         }
