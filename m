Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F6B253EAE
	for <lists+io-uring@lfdr.de>; Thu, 27 Aug 2020 09:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbgH0HLi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Aug 2020 03:11:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60704 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727864AbgH0HLh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Aug 2020 03:11:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598512296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wA1E5VINX4qFtBzgdOzHpby4Hxj21VGI22LvPkpMV1U=;
        b=ExLrN3liKg6jlt6zP8kb9DZoU+h5c+hMO9VnhqMRQbNR0fg86o84SsIH2jJTTc5rQbA40p
        8Fp7QA/4maReYsT1fQFAhwqndPWeV7zWD8x5+q64ae2sC6cEF8gQXML00sBtW84c3/F1QL
        MEI5Bf2EuPwFS/iBpYoMjDRiS5fjZCA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-W6aADYN9Opqn7VKq3yAWVA-1; Thu, 27 Aug 2020 03:11:34 -0400
X-MC-Unique: W6aADYN9Opqn7VKq3yAWVA-1
Received: by mail-wr1-f69.google.com with SMTP id m7so1155137wrb.20
        for <io-uring@vger.kernel.org>; Thu, 27 Aug 2020 00:11:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wA1E5VINX4qFtBzgdOzHpby4Hxj21VGI22LvPkpMV1U=;
        b=VTiIXkw072QFHKXSUu7voZxIFOAMRpckAizJH9P7CGqHkps4Io1JSSzH5I/GDWkD0B
         vOvSyRD2diknu6iZ8JsP4PEimpauhkz/ATnZfPZi7JG97m+Do85nOzWhBmoT9ScEE9fM
         0wf7tQfqSC4IR4nbeQ/AFKMQrGcMDbH1mD8MIeEbiy/M6cQCs23KFGjDzLQl+nyrya/S
         a1aT9mu/6/D6pLK2SdnnO/Rf+piMW7HLi9vGwLhEWjk1etvxsbh3Bg0aBGCi6Lm/8IWF
         LIWVGqhsrTIvHHx2G2N6fBsgl7Y5bD6zRfrBMUUjqVncEefR2109TDcbJkiGbjlXLRtm
         hCkQ==
X-Gm-Message-State: AOAM533MniEaS9G4myLBBrDfDvxnvsi5dRf6Kw3MlYQHod59ncqcOH22
        1vfDmPTPjhRvYWeyK+UdZ98wNi40Uq6eSxhuHqTiaXmcM9dQhq0O5cJbUlItudAVMgSzYCwe9gP
        gcrcX4rX5gdi+AXA6ZLc=
X-Received: by 2002:a1c:e1d6:: with SMTP id y205mr5699022wmg.92.1598512292923;
        Thu, 27 Aug 2020 00:11:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQLLfupwT3htk3SZsVuWhYX6+i7LaFRQaqAJ1Z0qPYkQk0csrl0zkKVvfPCI25zfzRfGsBQw==
X-Received: by 2002:a1c:e1d6:: with SMTP id y205mr5698987wmg.92.1598512292689;
        Thu, 27 Aug 2020 00:11:32 -0700 (PDT)
Received: from steredhat.lan ([5.180.207.22])
        by smtp.gmail.com with ESMTPSA id v3sm3099244wmh.6.2020.08.27.00.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 00:11:32 -0700 (PDT)
Date:   Thu, 27 Aug 2020 09:11:27 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Andreas Dilger <adilger@dilger.ca>,
        Kees Cook <keescook@chromium.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aleksa Sarai <asarai@suse.de>, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 1/3] io_uring: use an enumeration for
 io_uring_register(2) opcodes
Message-ID: <20200827071127.iqq4gt3d5bpsq4xu@steredhat.lan>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <20200813153254.93731-2-sgarzare@redhat.com>
 <202008261241.074D8765@keescook>
 <C1F49852-C886-4522-ACD6-DDBF7DE3B838@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C1F49852-C886-4522-ACD6-DDBF7DE3B838@dilger.ca>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 26, 2020 at 01:52:38PM -0600, Andreas Dilger wrote:
> On Aug 26, 2020, at 1:43 PM, Kees Cook <keescook@chromium.org> wrote:
> > 
> > On Thu, Aug 13, 2020 at 05:32:52PM +0200, Stefano Garzarella wrote:
> >> The enumeration allows us to keep track of the last
> >> io_uring_register(2) opcode available.
> >> 
> >> Behaviour and opcodes names don't change.
> >> 
> >> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> >> ---
> >> include/uapi/linux/io_uring.h | 27 ++++++++++++++++-----------
> >> 1 file changed, 16 insertions(+), 11 deletions(-)
> >> 
> >> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> >> index d65fde732518..cdc98afbacc3 100644
> >> --- a/include/uapi/linux/io_uring.h
> >> +++ b/include/uapi/linux/io_uring.h
> >> @@ -255,17 +255,22 @@ struct io_uring_params {
> >> /*
> >>  * io_uring_register(2) opcodes and arguments
> >>  */
> >> -#define IORING_REGISTER_BUFFERS		0
> >> -#define IORING_UNREGISTER_BUFFERS	1
> >> -#define IORING_REGISTER_FILES		2
> >> -#define IORING_UNREGISTER_FILES		3
> >> -#define IORING_REGISTER_EVENTFD		4
> >> -#define IORING_UNREGISTER_EVENTFD	5
> >> -#define IORING_REGISTER_FILES_UPDATE	6
> >> -#define IORING_REGISTER_EVENTFD_ASYNC	7
> >> -#define IORING_REGISTER_PROBE		8
> >> -#define IORING_REGISTER_PERSONALITY	9
> >> -#define IORING_UNREGISTER_PERSONALITY	10
> >> +enum {
> >> +	IORING_REGISTER_BUFFERS,
> > 
> > Actually, one *tiny* thought. Since this is UAPI, do we want to be extra
> > careful here and explicitly assign values? We can't change the meaning
> > of a number (UAPI) but we can add new ones, etc? This would help if an
> > OP were removed (to stop from triggering a cascade of changed values)...
> > 
> > for example:
> > 
> > enum {
> > 	IORING_REGISTER_BUFFERS = 0,
> > 	IORING_UNREGISTER_BUFFERS = 1,
> > 	...
> 
> Definitely that is preferred, IMHO, for enums used as part of UAPI,
> as it avoids accidental changes to the values, and it also makes it
> easier to see what the actual values are.
> 

Sure, I agree.

I'll put the values in the enumerations in the v5.

Thanks,
Stefano

