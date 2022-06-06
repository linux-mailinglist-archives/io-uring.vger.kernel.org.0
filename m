Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201EF53EAC9
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 19:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbiFFLwy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 07:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235777AbiFFLwx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 07:52:53 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474D210CD
        for <io-uring@vger.kernel.org>; Mon,  6 Jun 2022 04:52:14 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id r204-20020a1c44d5000000b0039c55c50482so148861wma.0
        for <io-uring@vger.kernel.org>; Mon, 06 Jun 2022 04:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CWvsDpmb9aoWZSw0w9qyVTNu5dEh0Xri0WzmJyC9vWU=;
        b=KFAf+A4etENIbmWb2tYrQlVGH2XGoS7LimdbOI6spSSL/e50zrVvOzlwV1sEvPQS2c
         rex7l0sV8N3u+VbgDm/sOD8GLMnV19IW45M73WA+EHS0+k6M7Gz7JpROoEsQwQDJHQm1
         QHGJbY1jHKLlrgxo+3vxoMfnmTeMyRtNOAdL1e2idBlqYGXl3jwXB1gUWExDeNZUVff2
         xRuRg/Ew9qeJxcplV1Ctqy9dRYtCmqXEIgrvvTndUiIAqJWWUG9Y58VmBltwxlzUm9Tw
         1ZlHXXM8NZkZQwX/PFms0I/m6b4Ka2aN2hZRsAfUKDu4+4zFPGHxaYLHHloyCq0+B/4B
         1xwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CWvsDpmb9aoWZSw0w9qyVTNu5dEh0Xri0WzmJyC9vWU=;
        b=VC1xkpZ7ayM2yJeGUdKwymyMFHjVQ+MZQsTYhoeW0piuvdpCS4oht7zk2xKsgyJ3Zo
         rZP7p98d9YDhqo0d5ahUzMPnHUGkQ+oQ3zp+B0TlaYb6/1cr1m7UsioggHuwP//1TvrP
         0cVl67Q7X6hLX+GoUQWy4QMT4Vbs23EXyikK40i6106a+74eGRY++pVsUKAjYdpBM/gY
         ah53+TxGBSzYQBLsv2rdwTZDYfuIRAGJISVAVd6vrFDhnnb3gsMeMaHMUV89B3TlVU/9
         fzUC8P3MbHpKUkvzL3HW70lBSty6ZdtcYcYwEXO4d4W6GN0aUU7sDZMA46rvbDGcF9vG
         inkQ==
X-Gm-Message-State: AOAM530pChaFw/uL/5y/HiNHnuHA5iRkaY0OC4funa42zELtfgZ1nQHK
        KPk2EkEPsswq9iAEh4pVTfk=
X-Google-Smtp-Source: ABdhPJzRXeCdyhSHqkt9CPGLU032z9s6ZQpMlTsLNmrjTsWjUTv652s080pNhoDqyPrWTWMvXA+YWA==
X-Received: by 2002:a05:600c:1d05:b0:397:6fd1:6959 with SMTP id l5-20020a05600c1d0500b003976fd16959mr22816535wms.202.1654516332722;
        Mon, 06 Jun 2022 04:52:12 -0700 (PDT)
Received: from [192.168.43.77] (82-132-232-174.dab.02.net. [82.132.232.174])
        by smtp.gmail.com with ESMTPSA id l19-20020a1ced13000000b0039c1396b495sm17170571wmh.9.2022.06.06.04.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 04:52:12 -0700 (PDT)
Message-ID: <f9bb85c4-d7e6-203d-f202-458cf558ad31@gmail.com>
Date:   Mon, 6 Jun 2022 12:51:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v1 5/5] Add io_uring data structure build assertion
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220606061209.335709-1-ammarfaizi2@gnuweeb.org>
 <20220606061209.335709-6-ammarfaizi2@gnuweeb.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220606061209.335709-6-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/6/22 07:12, Ammar Faizi wrote:
> Ensure io_uring data structure consistent between the kernel and user
> space. These assertions are taken from io_uring.c in the kernel.

I don't see why would we do that. io_uring.h is only intended to be
copied from the kernel's uapi without some weird changes in structs,
I really really hope nobody will be trying to modify it separately.

But the real downside is that we'll need to maintain a full
duplicate of it and keep updating both for no good reason.
What do I miss?

> 
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> ---
>   src/Makefile       |  3 ++-
>   src/build_assert.h | 57 ++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 59 insertions(+), 1 deletion(-)
>   create mode 100644 src/build_assert.h
> 
> diff --git a/src/Makefile b/src/Makefile
> index 12cf49f..aed3c40 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -7,7 +7,8 @@ libdevdir ?= $(prefix)/lib
>   
>   CPPFLAGS ?=
>   override CPPFLAGS += -D_GNU_SOURCE \
> -	-Iinclude/ -include ../config-host.h
> +	-Iinclude/ -include ../config-host.h \
> +	-include build_assert.h
>   CFLAGS ?= -g -O2 -Wall -Wextra -fno-stack-protector
>   override CFLAGS += -Wno-unused-parameter -Wno-sign-compare -DLIBURING_INTERNAL
>   SO_CFLAGS=-fPIC $(CFLAGS)
> diff --git a/src/build_assert.h b/src/build_assert.h
> new file mode 100644
> index 0000000..5b2a9c6
> --- /dev/null
> +++ b/src/build_assert.h
> @@ -0,0 +1,57 @@
> +/* SPDX-License-Identifier: MIT */
> +
> +#ifndef LIBURING_BUILD_ASSERT_H
> +#define LIBURING_BUILD_ASSERT_H
> +
> +#include "liburing/io_uring.h"
> +#include "lib.h"
> +
> +static inline __attribute__((__unused__)) void io_uring_build_assert(void)
> +{
> +#define __BUILD_BUG_VERIFY_ELEMENT(stype, eoffset, etype, ename) do { \
> +	BUILD_BUG_ON(offsetof(stype, ename) != eoffset); \
> +	BUILD_BUG_ON(sizeof(etype) != sizeof_field(stype, ename)); \
> +} while (0)
> +
> +#define BUILD_BUG_SQE_ELEM(eoffset, etype, ename) \
> +	__BUILD_BUG_VERIFY_ELEMENT(struct io_uring_sqe, eoffset, etype, ename)
> +	BUILD_BUG_ON(sizeof(struct io_uring_sqe) != 64);
> +	BUILD_BUG_SQE_ELEM(0,  __u8,   opcode);
> +	BUILD_BUG_SQE_ELEM(1,  __u8,   flags);
> +	BUILD_BUG_SQE_ELEM(2,  __u16,  ioprio);
> +	BUILD_BUG_SQE_ELEM(4,  __s32,  fd);
> +	BUILD_BUG_SQE_ELEM(8,  __u64,  off);
> +	BUILD_BUG_SQE_ELEM(8,  __u64,  addr2);
> +	BUILD_BUG_SQE_ELEM(16, __u64,  addr);
> +	BUILD_BUG_SQE_ELEM(16, __u64,  splice_off_in);
> +	BUILD_BUG_SQE_ELEM(24, __u32,  len);
> +	BUILD_BUG_SQE_ELEM(28,     __kernel_rwf_t, rw_flags);
> +	BUILD_BUG_SQE_ELEM(28, /* compat */   int, rw_flags);
> +	BUILD_BUG_SQE_ELEM(28, /* compat */ __u32, rw_flags);
> +	BUILD_BUG_SQE_ELEM(28, __u32,  fsync_flags);
> +	BUILD_BUG_SQE_ELEM(28, /* compat */ __u16,  poll_events);
> +	BUILD_BUG_SQE_ELEM(28, __u32,  poll32_events);
> +	BUILD_BUG_SQE_ELEM(28, __u32,  sync_range_flags);
> +	BUILD_BUG_SQE_ELEM(28, __u32,  msg_flags);
> +	BUILD_BUG_SQE_ELEM(28, __u32,  timeout_flags);
> +	BUILD_BUG_SQE_ELEM(28, __u32,  accept_flags);
> +	BUILD_BUG_SQE_ELEM(28, __u32,  cancel_flags);
> +	BUILD_BUG_SQE_ELEM(28, __u32,  open_flags);
> +	BUILD_BUG_SQE_ELEM(28, __u32,  statx_flags);
> +	BUILD_BUG_SQE_ELEM(28, __u32,  fadvise_advice);
> +	BUILD_BUG_SQE_ELEM(28, __u32,  splice_flags);
> +	BUILD_BUG_SQE_ELEM(32, __u64,  user_data);
> +	BUILD_BUG_SQE_ELEM(40, __u16,  buf_index);
> +	BUILD_BUG_SQE_ELEM(40, __u16,  buf_group);
> +	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
> +	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
> +	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
> +	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
> +
> +	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
> +		     sizeof(struct io_uring_rsrc_update));
> +	BUILD_BUG_ON(sizeof(struct io_uring_rsrc_update) >
> +		     sizeof(struct io_uring_rsrc_update2));
> +}
> +
> +#endif

-- 
Pavel Begunkov
