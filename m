Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75ECA15B3BA
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2020 23:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbgBLWbh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Feb 2020 17:31:37 -0500
Received: from mail-ot1-f41.google.com ([209.85.210.41]:40417 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729127AbgBLWbh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Feb 2020 17:31:37 -0500
Received: by mail-ot1-f41.google.com with SMTP id i6so3609707otr.7
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2020 14:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u0FLnSCqqGHWyjrsfwKf//FoomwU5X28uXFQTPY5uSg=;
        b=OYB/6fgYMlYs+RAyknJD3S8FTPFbzUE4t6jPWNcuTlU0lv/XhuYP5LVXk03maOFXpf
         9TGa0/ziHmrEGGPA35mAQbyTBIy8dAH0UOYdxw1fW4acqi6hqzlAai09UFkrhbRVHwNs
         8k+h1gIRxwCeKKKAlOnfUEn6E3FxnbkTIvf4FR3tvkSscWvvXeneIOxGnWBA1IJyZaYN
         YHjpDS58WLj7a5tUd0zPNJTjjdmFfmT+rKTPts9lnTRG2AerCx/Kto1o0utdYRKBmcKH
         GyfraLkpZ1LxCRl3T0Zb9QRPjLTBGVEeArsCj+cLwcQnpbEpwgFrG0L/0V/t5oPv1bv8
         jJKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u0FLnSCqqGHWyjrsfwKf//FoomwU5X28uXFQTPY5uSg=;
        b=NpO6g0JZ2RhYInm4KnVGRkSs0/jcXpynRCBLIko8vNWTYKqclk1ZLXP08EaizOtrSw
         HIz/Dlr0VuCS5ZMdPJQF1LSOco66usIh6OWIYFH577vmj9CpQ0uKuP3yGXkfChbPihZB
         7v8QvEyshkepxXQR6AF5qzNufza2QxIset0cwe1DT//dpPQFLGcH2Wgd+g45sUr6LHAq
         8c47YILBlPu7GxZkvBuHVpzNhm+KKHHjcEyWRVXXiXYFk0cCnVPAqHYTbgPxcmjjU1VX
         MYgsogYXpb9gQT/5t7w4L/fnAzz5+DBBy2jguxX6Cv7zXBTed7aIQQIGACCsitLSOeYf
         wy7A==
X-Gm-Message-State: APjAAAW9BsZ6qlS0T8deF4lC25TKxxiZO/rwr/7nVpE1XMx6hhArjb8V
        4uAKWjiQG0o/Lf4Liw+4v0dcDJg901pbv7Dk+1B5op35e3XKaA==
X-Google-Smtp-Source: APXvYqxHoxGdwwxQrgz29ZWZbz8CAcsk25+AiBltz4mibV6XnIh3ZN9MEkjr6ukrOh8Oz4/j/eUg/Z7xCiFm3SGoq3s=
X-Received: by 2002:a05:6830:22cc:: with SMTP id q12mr11447191otc.110.1581546695952;
 Wed, 12 Feb 2020 14:31:35 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zZ7OFgqp88HrpKt4sW10AzjasaPkKSM7Gv68TiJt_3RxQ@mail.gmail.com>
 <6c32ccd9-6d00-5c57-48cc-25fd4f48d5e7@kernel.dk> <CAD-J=zYNXej09AarnJDqgvX5U5aNLh4ez6hddWzWvg-625c1mA@mail.gmail.com>
 <c192d9b8-fab9-1c29-7266-acd48b380338@kernel.dk> <CAD-J=zYUCFG=RTf=d98sBD=M4yg+i=qag2X9JxFa-KW0Un19Qw@mail.gmail.com>
 <059cfdbf-bcfe-5680-9b0a-45a720cf65c5@kernel.dk>
In-Reply-To: <059cfdbf-bcfe-5680-9b0a-45a720cf65c5@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 12 Feb 2020 23:31:09 +0100
Message-ID: <CAG48ez0ffvnfnPEemkKn1ZkGE-uAsAyBcAeJWdJ8j-eVeyaxfQ@mail.gmail.com>
Subject: Re: Kernel BUG when registering the ring
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Glauber Costa <glauber@scylladb.com>,
        io-uring <io-uring@vger.kernel.org>,
        Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Feb 11, 2020 at 7:58 PM Jens Axboe <axboe@kernel.dk> wrote:
[...]
> @@ -849,6 +857,8 @@ void io_wq_cancel_all(struct io_wq *wq)
>         for_each_node(node) {
>                 struct io_wqe *wqe = wq->wqes[node];
>
> +               if (!node_online(node))
> +                       continue;
>                 io_wq_for_each_worker(wqe, io_wqe_worker_send_sig, NULL);
>         }
>         rcu_read_unlock();

What is this going to do if a NUMA node is marked as offline (through
a call to node_set_offline() from try_offline_node()) while it has a
worker running, and then afterwards, with the worker still running,
io_wq_cancel_all() is executed? Is that going to potentially hang
because some op is still executing on that node's worker? Or is there
a reason why that can't happen?

[...]
> @@ -1084,6 +1100,8 @@ void io_wq_flush(struct io_wq *wq)
>         for_each_node(node) {
>                 struct io_wqe *wqe = wq->wqes[node];
>
> +               if (!node_online(node))
> +                       continue;
>                 init_completion(&data.done);
>                 INIT_IO_WORK(&data.work, io_wq_flush_func);
>                 data.work.flags |= IO_WQ_WORK_INTERNAL;

(io_wq_flush() is dead code since 05f3fb3c5397, right? Are there plans
to use it again?)
