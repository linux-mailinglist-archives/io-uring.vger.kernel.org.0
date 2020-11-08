Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBBA2AAE33
	for <lists+io-uring@lfdr.de>; Mon,  9 Nov 2020 00:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgKHXSQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 Nov 2020 18:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727949AbgKHXSP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 Nov 2020 18:18:15 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76E2C0613CF
        for <io-uring@vger.kernel.org>; Sun,  8 Nov 2020 15:18:15 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id k1so6646763ilc.10
        for <io-uring@vger.kernel.org>; Sun, 08 Nov 2020 15:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=69ZPEe7hNRDLTNb7t4JQwfRwAHTVryHFkvxizWRVyuQ=;
        b=M4dcL/BQPPV87++q1HgQRpB2ZYgU4xmMQJMwAI7Ry1anjHY5uikSO2jc5KXdfJO6Pl
         8HLjCD9oIeWjzURdzxnXsZU3rl5dclzy4tVRrDPKbnD9nj4lHqfAQl0sd4+RRYQUvUz5
         3JFWxpJXMert1wGM4tKS4qBYEMUFn9uvPeIia+G0bn2k7LkxrH3WzQ77HcRC0mml30E5
         dvW0jsTL2F1qbmrnkp1aCyJdglWaSf/5mJvE8v86rgwwLw24jtjnBTA6P07jaguYjGBk
         uMdaqIw0GYF3q6nD8pK3b4OlcdZWD7b9iThE2EmaPDMjXGlJZv3xxIoFYeKKfiP6vPAS
         qQtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=69ZPEe7hNRDLTNb7t4JQwfRwAHTVryHFkvxizWRVyuQ=;
        b=DCTD1ZDEMGMzMEGXcuREs6Jn4L9MWv3MBe+HfoY9YkWOE0peijuDPt5UsHUZdKjk6F
         hYu+lSOz3Do9pilen2dosnfj2OBId/xrDJofu8FtFe1HSIJKvxR2mnzvc/5ChtPoMmgu
         f/G1LR0L/PpW8muLtIXSoEb5tSiYCUqlX1MBPHkv1ucPk1LgrB19BbG2I8iOZIhGWoYP
         AhFXjNjM+mOk5mD6qrNOUmV7jfXzjd9UD5zd0G8k96t793Gt5owRZ/eazGz/IzGkGlRT
         4Stkn2e8TaJoizXk9F3Nt5t5oBM+Y8hpfF4rl2BHAjk5gh3EkS6vhySlqpBL3W1VCzxw
         wj2g==
X-Gm-Message-State: AOAM533rLk439bi907jSL9OMoGRxRKxCExtBkSGaghihQIqYHFasLkcH
        w7viEDKRdNgU3r9fVh0r/PV8nahgX9I=
X-Google-Smtp-Source: ABdhPJzGLprVqcX++y3p3wUeBR4lfq9XUFVdpmw9ZaeCF+8WnII0y2iZaG0Lc5Lyf7WIDrN5Rz8qeA==
X-Received: by 2002:a92:9183:: with SMTP id e3mr8266308ill.111.1604877494863;
        Sun, 08 Nov 2020 15:18:14 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:59f:e9df:76ab:8876])
        by smtp.googlemail.com with ESMTPSA id b9sm1670938ila.51.2020.11.08.15.18.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Nov 2020 15:18:14 -0800 (PST)
Subject: Re: io-uring and tcp sockets
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <5324a8ca-bd5c-0599-d4d3-1e837338a7b5@gmail.com>
 <cd729952-d639-ec71-4567-d72c361fe023@samba.org>
 <f2f31220-3275-9201-0b58-a7bef4e2d51d@kernel.dk>
 <fb72cffc-87f9-6072-3f3a-6648aacd310e@gmail.com>
 <fb127003-e845-0586-1866-67788585234d@samba.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9428d573-7155-0e4c-8c03-85bada9a0567@gmail.com>
Date:   Sun, 8 Nov 2020 16:18:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <fb127003-e845-0586-1866-67788585234d@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/4/20 10:08 AM, Stefan Metzmacher wrote:
> sendmsg has msg_control, I think we'll need more interaction with the socket layer here
> in order to wait in a single low level ->sendmsg_locked() call.
> 
> I know IORING_OP_SENDMSG doesn't support msg_control currently, but I hope to get that fixed in future.

That does not work. __io_queue_sqe calls io_issue_sqe with the
force_nonblock flag set. io_send and io_sendmsg respond to that flag by
setting MSG_DONTWAIT in the respective socket call. Hence, my question
about the short send being by design.
