Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD61077E41B
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 16:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343558AbjHPOt0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 10:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245477AbjHPOtQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 10:49:16 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3229C269F
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 07:49:15 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6874a386ec7so1277544b3a.1
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 07:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692197354; x=1692802154;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bB7XWSnRRk5uRFy5Bhr/rMcZ+NwcVc4eZMs4l+L6BC4=;
        b=YrSmXVUZyUbo5/DHpr/E/N6JKUMRNyWAlNcQKxpIO421IUV5dtRDUpmKeQEyjad3kl
         LVoatROUhIqQtFSZstzi6qxwoQpM5aMp5sWMhkkeOekdSIuNh/JMKt74XvTB2eHAy2pw
         ojrt9yVSwSO65vG3IWKMcQOetkmIyUKspirukH4yyFeflXEX/8mkBfOKORXncW5M0Oaw
         FDeK9Q42/IJDJaSquU/1oO9ysT0cLRI1pglMJ6MpvaYFXXPU9TmfKngTk1plVyyKIgaS
         qNmWw1ADfOsc24piOnyPh6inDUHCfDwbla+Jz2MYVpZpLRddzFRqQSPKguCyloQMwvB3
         oPGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692197354; x=1692802154;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bB7XWSnRRk5uRFy5Bhr/rMcZ+NwcVc4eZMs4l+L6BC4=;
        b=U3OS/udjxXfTtThWuibpbQzikHh4SWlDk0fS3/bkXy0IHE5V3WSY72yNZZ6+5v2iOr
         XOXRuT1hRW8jKM8md8dPVZziyEjD2+LIqirmKlTRQIIJ/P6pKdHSW8NXLMLfr05+xai2
         24XuFdsrL7uSIMeGaxp2N/rDP4r2F210DwVhfODahTSuYumoWfubAvW1MLgstdX1w6R9
         aa7iuTRX+/pmPrSU5zQ3+pEizet0YtQyBJagjPk3DAur+Rb3L8mHaTTrq1mve3vB2fw4
         9pNay3i5DK7O+l/ggMdmn08koy0ak23GKDT4UhISuPNy6MI+4Y+Gl0UueEv+WKJTXYRg
         IAqQ==
X-Gm-Message-State: AOJu0YwX9eU7nw1/u/eMXSJD3QzFkJJx2ayaSVBdYItZL8QHuICtdFy1
        0QU8/acIDtBWXkWqj23E1q+9RKbjNBABp6nSIvE=
X-Google-Smtp-Source: AGHT+IGt+WgkuYD3me2WG5lk5UQqztjdQYUhOqr4S22DrzYSklwqN63sdxu5wSD7u9F1rOSiaU4XFQ==
X-Received: by 2002:a05:6a21:6d9e:b0:140:ca4c:740d with SMTP id wl30-20020a056a216d9e00b00140ca4c740dmr3232747pzb.4.1692197354559;
        Wed, 16 Aug 2023 07:49:14 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n12-20020aa7904c000000b00688214cff65sm7617093pfo.44.2023.08.16.07.49.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Aug 2023 07:49:13 -0700 (PDT)
Message-ID: <804a4c7b-f5ca-4f02-8dc7-893bbefd798b@kernel.dk>
Date:   Wed, 16 Aug 2023 08:49:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible io_uring related race leads to btrfs data csum mismatch
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        io-uring@vger.kernel.org
References: <95600f18-5fd1-41c8-b31b-14e7f851e8bc@gmx.com>
 <51945229-5b35-4191-a3f3-16cf4b3ffce6@kernel.dk>
In-Reply-To: <51945229-5b35-4191-a3f3-16cf4b3ffce6@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/23 8:33 AM, Jens Axboe wrote:
>> However I didn't see any io_uring related callback inside btrfs code,
>> any advice on the io_uring part would be appreciated.
> 
> io_uring doesn't do anything special here, it uses the normal page cache
> read/write parts for buffered IO. But you may get extra parallellism
> with io_uring here. For example, with the buffered write that this most
> likely is, libaio would be exactly the same as a pwrite(2) on the file.
> If this would've blocked, io_uring would offload this to a helper
> thread. Depending on the workload, you could have multiple of those in
> progress at the same time.

I poked a bit at fsstress, and it's a bit odd imho. For example, any aio
read/write seems to hardcode O_DIRECT. The io_uring side will be
buffered. Not sure why there are those differences and why buffered/dio
isn't a variable. But this does mean that these are certainly buffered
writes with io_uring.

Are any of the writes overlapping? You could have a situation where
writeA and writeB overlap, and writeA will get punted to io-wq for
execution and writeB will complete inline. In other words, writeA is
issued, writeB is issued. writeA goes to io-wq, writeB now completes
inline, and now writeA is done and completed. It may be exposing issues
in btrfs. You can try the below patch, which should serialize all the
writes to a given file. If this makes a difference for you, then I'd
strongly suspect that the issue is deeper than the delivery mechanism of
the write.

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 6641a525fe5d..034cbba27c6e 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -2317,6 +2317,7 @@ do_uring_rw(opnum_t opno, long r, int flags)
 		off %= maxfsize;
 		memset(buf, nameseq & 0xff, len);
 		io_uring_prep_writev(sqe, fd, &iovec, 1, off);
+		sqe->flags |= IOSQE_ASYNC;
 	} else {
 		off = (off64_t)(lr % stb.st_size);
 		io_uring_prep_readv(sqe, fd, &iovec, 1, off);

-- 
Jens Axboe

