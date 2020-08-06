Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F40723D7B9
	for <lists+io-uring@lfdr.de>; Thu,  6 Aug 2020 09:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728860AbgHFHuD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Aug 2020 03:50:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44377 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728850AbgHFHtq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Aug 2020 03:49:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596700180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xB6SfwN9zZAFK1inviExT4PSWJ9s32aoWCOt/UwHdpI=;
        b=OiMKltL0s/mtZ9+RLEkA8jiypTUUTAY+mdwMlBxrn/k9v3ZXUYswSIqCnFvA38mT1bwaeE
        wNjZ+3EKMpFIASdnAOEU1cJWvTznJKDk0CY1konzJ/Xx4Jn4zrpwsISFcQqqftMLNM/1Wz
        bIF0zC0gJYCFD9DAW6a4rXHt8YNa5mc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-KWaqNNlaOKu94TXiFUW_JA-1; Thu, 06 Aug 2020 03:49:38 -0400
X-MC-Unique: KWaqNNlaOKu94TXiFUW_JA-1
Received: by mail-wr1-f69.google.com with SMTP id z1so14409631wrn.18
        for <io-uring@vger.kernel.org>; Thu, 06 Aug 2020 00:49:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xB6SfwN9zZAFK1inviExT4PSWJ9s32aoWCOt/UwHdpI=;
        b=K/UeIwbNfWmQeCJJgoZGNL0iFxcBW+LX66akZKrJmOtoXeNjDWSKHEkpUBW9530DWo
         ejLLybZp8RSpLoX4I/9RhIioIl8MzYgfQiKbRtuX/n1VJbO/x4mCkfZzPnJfjt913sKo
         bNFEQ0xRpzfv266M3aA6YP2dwYIfqX8qtHRkjFmjFX/wo07ZKy4BDNTPKzxFOh1klDq9
         oGNRF0kcyg8jpcNw3TeXtuQlqQa3K7jjLiO2+5xen3mBZ1j0DIuaIGgLzflxzJSuwf0P
         Ef4vXOfcEVyWDAWtC+ZMPcUy7e3Db42FhWfphyBs8YlMKolf0Ag3NR9CErqMcQs/E7Xg
         iIyg==
X-Gm-Message-State: AOAM532oVDIq/u7WhBqy6MZkaCw4ZPNv/Jv09IP1SeefMeeF01xqJQSB
        vDOFtYN5IA4Px2sK9haZQjvTe2Il91ggGAzZG3jwODKFPKPWnBjFg+15S0+rwJLRDShAI48ykMN
        0uwUm1KA9xjrieFdnl+s=
X-Received: by 2002:a1c:e244:: with SMTP id z65mr6663774wmg.34.1596700177237;
        Thu, 06 Aug 2020 00:49:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZ5kIFKf/UdkmWPj9U+O2NxXnYswiWnhDgQNIX/nObMw+EYpBVxwz7xoUqJ3nnWezsts3JEg==
X-Received: by 2002:a1c:e244:: with SMTP id z65mr6663754wmg.34.1596700176991;
        Thu, 06 Aug 2020 00:49:36 -0700 (PDT)
Received: from steredhat ([5.180.207.22])
        by smtp.gmail.com with ESMTPSA id l18sm5580825wrm.52.2020.08.06.00.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 00:49:36 -0700 (PDT)
Date:   Thu, 6 Aug 2020 09:49:29 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Jeff Moyer <jmoyer@redhat.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aleksa Sarai <asarai@suse.de>,
        Sargun Dhillon <sargun@sargun.me>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>
Subject: Re: [PATCH v3 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Message-ID: <20200806074929.bl6utxrmmx3hf2y2@steredhat>
References: <20200728160101.48554-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728160101.48554-1-sgarzare@redhat.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Gentle ping.

I'll rebase on master, but if there are any things that I can improve,
I'll be happy to do.

Thanks,
Stefano

On Tue, Jul 28, 2020 at 06:00:58PM +0200, Stefano Garzarella wrote:
> v3:
>  - added IORING_RESTRICTION_SQE_FLAGS_ALLOWED and
>    IORING_RESTRICTION_SQE_FLAGS_REQUIRED
>  - removed IORING_RESTRICTION_FIXED_FILES_ONLY opcode
>  - enabled restrictions only when the rings start
> 
> RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redhat.com
> 
> RFC v1: https://lore.kernel.org/io-uring/20200710141945.129329-1-sgarzare@redhat.com
> 
> Following the proposal that I send about restrictions [1], I wrote this series
> to add restrictions in io_uring.
> 
> I also wrote helpers in liburing and a test case (test/register-restrictions.c)
> available in this repository:
> https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)
> 
> Just to recap the proposal, the idea is to add some restrictions to the
> operations (sqe opcode and flags, register opcode) to safely allow untrusted
> applications or guests to use io_uring queues.
> 
> The first patch changes io_uring_register(2) opcodes into an enumeration to
> keep track of the last opcode available.
> 
> The second patch adds IOURING_REGISTER_RESTRICTIONS opcode and the code to
> handle restrictions.
> 
> The third patch adds IORING_SETUP_R_DISABLED flag to start the rings disabled,
> allowing the user to register restrictions, buffers, files, before to start
> processing SQEs.
> 
> Comments and suggestions are very welcome.
> 
> Thank you in advance,
> Stefano
> 
> [1] https://lore.kernel.org/io-uring/20200609142406.upuwpfmgqjeji4lc@steredhat/
> 
> Stefano Garzarella (3):
>   io_uring: use an enumeration for io_uring_register(2) opcodes
>   io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
>   io_uring: allow disabling rings during the creation
> 
>  fs/io_uring.c                 | 167 ++++++++++++++++++++++++++++++++--
>  include/uapi/linux/io_uring.h |  60 +++++++++---
>  2 files changed, 207 insertions(+), 20 deletions(-)
> 
> -- 
> 2.26.2
> 

