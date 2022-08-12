Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF6B59172A
	for <lists+io-uring@lfdr.de>; Sat, 13 Aug 2022 00:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbiHLWMB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 18:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiHLWMA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 18:12:00 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BC6B3B22
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:11:59 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 24so1855260pgr.7
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=URO+NnmGqtVXukIi80C+7yuMDN9oqb2FV53n7jjrsHo=;
        b=Hv26K5+yMZJgVdrwZPQy/DTPMq/vYaFgwoP2g2AydRnVmH6Up5aOeN6RPUUww6fZpT
         Vm+JT4Ko8ksJAHNaG5BB6q+YzG7onPufhcHGqENdAGvOPR8buP5ZCQRNVvakRAmmD1wi
         fILAT6IWDX2fONiSsOOAbI2TU2YTyuj0sdPbfdsKXceSQTtf01j9LbVMVjsoEDoP+7o2
         FAQuKSICZT6UMEsCDkyE9yDpGP1ob8rWgs98ARgCJTP8FURarfmheST5H0MCGMYniaBc
         YM1Bo5PE4LHBGVZgDH3lXRAQQfbOsx6Pxo6aA7PYFuyKqH44A8/dPDhguKd/Vr4EpWgE
         RBbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=URO+NnmGqtVXukIi80C+7yuMDN9oqb2FV53n7jjrsHo=;
        b=MUXrj9j44GoJk8dwXY6hlXyfKbE7gkfPooHdK4XgRYAHg+9+J7GEkg3X/mZ4+J9HhK
         srXIOmzN0q7O9jsvhMO3caoOXCaRdHg2X9R+Vw8p2oLz4ONOFNdaz1LfMb6Qre1psRAJ
         xB1wJNjpTCgCoXVOiNpKEjSwvLlm6WwornJKSQuCPCTGOfjeRiHy8ws882nSdbNA5Yl/
         +xgH/D/YsezB9Kk9AJHrGeP4XqR1kFKRO3kPDhezrRs9kfwMWVzOTIOXf8jNy6264XWK
         pUR5GHPlcwdzMvIdcJFd2g4/ndUzsV6Uduko+wnXblfOUh5hHMWyGLVITppnIAcTyAWx
         5YUA==
X-Gm-Message-State: ACgBeo1AzHmlXJ1eawFMBUheeWAulBevEBW7a96MGXthcewTIDve7RKS
        4YXrCNrwR8U1Vktsx08LF+5EiPpgNwQLQg==
X-Google-Smtp-Source: AA6agR7mQdrgMA2g9XLQ+5lWWQm1lWpI5ylTnD+9n7DFRJz28chf8L+NW4npg+1cC9WhX7V2/u4mBg==
X-Received: by 2002:a05:6a00:1343:b0:52e:8174:fc37 with SMTP id k3-20020a056a00134300b0052e8174fc37mr5849706pfu.32.1660342318805;
        Fri, 12 Aug 2022 15:11:58 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i16-20020a056a00225000b0052e9cee1f5fsm2103332pfu.29.2022.08.12.15.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 15:11:58 -0700 (PDT)
Message-ID: <bb3d5834-ebe2-a82d-2312-96282b5b5e2e@kernel.dk>
Date:   Fri, 12 Aug 2022 16:11:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>
References: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
 <D92A7993-60C6-438C-AFA9-FA511646153C@kernel.dk>
 <6458eb59-554a-121b-d605-0b9755232818@kernel.dk>
 <ca630c3c-80ad-ceff-61a9-63b253ba5dbd@kernel.dk>
 <433f4500-427d-8581-b852-fbe257aa6120@kernel.dk>
 <CAHk-=wi_oveXZexeUuxpJZnMLhLJWC=biyaZ8SoiNPd2r=6iUg@mail.gmail.com>
 <CAHk-=wj_2autvtY36nGbYYmgrcH4T+dW8ee1=6mV-rCXH7UF-A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wj_2autvtY36nGbYYmgrcH4T+dW8ee1=6mV-rCXH7UF-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/22 3:54 PM, Linus Torvalds wrote:
> On Fri, Aug 12, 2022 at 2:43 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> I think was seeing others (I got hundreds of lines or errors), but now
>> that I've blown things away I can't recreate it. My allmodconfig build
>> just completed with no sign of the errors I saw earlier.
> 
> Oh, and immediately after sending that email,  I got the errors back.
> 
> Because of the randstruct issue, I did another "git clean" (to make
> sure the random seed was gone and recreated) and started a new
> allmodconfig build.
> 
> And now I see the error again.
> 
> It does seem to be only 'struct io_cmd_data', but since this seems to
> be about random layout, who knows. The "hundreds of lines" is because
> each error report ends up being something like 25 lines in size, so
> you don't need a lot of them to get lots and lots of lines.
> 
> The ones I see in my *current* build are all that
> 
>   496 |         BUILD_BUG_ON(cmd_sz > sizeof(struct io_cmd_data));
> 
> add there's apparently six of them (so the "hundreds of lines" was
> apparently "only" 150 lines of errors), here's the concise "inlined
> from" info:
> 
>     inlined from ?io_prep_rw? at io_uring/rw.c:38:21:
>     inlined from ?__io_import_iovec? at io_uring/rw.c:353:21,
>     inlined from ?io_import_iovec? at io_uring/rw.c:406:11,
>     inlined from ?io_rw_prep_async? at io_uring/rw.c:538:8,
>     inlined from ?io_readv_prep_async? at io_uring/rw.c:551:9:
>     inlined from ?io_read? at io_uring/rw.c:697:21:
>     inlined from ?io_write? at io_uring/rw.c:842:21:
>     inlined from ?io_do_iopoll? at io_uring/rw.c:997:22:
> 
> in case that helps.

Thanks it does - so it's just io_rw, and hence it's just kiocb that is
problematic because of that layout randomization. What we really want is
for:

struct io_cmd_data {
	struct file		*file;
	/* each command gets 56 bytes of data */
	__u8			data[56];
};

to be == max-of-any-request-type data. Which was 56 bytes before, io_rw
and a few others were at that size. But if kiocb changes in an unlucky
fashion and we get the u16 and int interspersed between different types,
then struct kiocb growns and then io_rw as a result. And then the
compile blows up.

The patch was obviously a good thing since it found this, as this
would've caused some weird breakage that would've been hard to reproduce
unless your own build ended up having kiocb be larger as well.

Question is what to do about it. I can't think of a good way to size
io_cmd_data appropriately. We can union an io_rw in there, since that's
the biggest one and I _think_ the only one that'd hit this due to the
randomization. If I'm wrong, then it'd break compile again obviously.

Or we can ensure that kiocb doesn't get re-organized such that we add
more holes/padding. But that's also kind of weird.

Ideally we'd have a compile time way to check all structs, but that
becomes unwieldy.

For that one suggestion, I suspect this will fix your issue. It's
obviously not a thing of beauty...

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 677a25d44d7f..c83dedeb44b9 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -481,14 +481,29 @@ struct io_cqe {
 	};
 };
 
+struct io_rw {
+	/* NOTE: kiocb has the file as the first member, so don't do it here */
+	struct kiocb			kiocb;
+	u64				addr;
+	u32				len;
+	rwf_t				flags;
+};
+
 /*
  * Each request type overlays its private data structure on top of this one.
- * They must not exceed this one in size.
+ * They must not exceed this one in size. We must ensure that this is big
+ * enough to hold any command type. Currently io_rw includes struct kiocb,
+ * which is marked as having a random layout for security reasons. This can
+ * cause it to grow in size if the layout ends up adding more holes or padding.
+ * Unionize io_cmd_data with io_rw to work-around this issue.
  */
 struct io_cmd_data {
-	struct file		*file;
-	/* each command gets 56 bytes of data */
-	__u8			data[56];
+	union {
+		struct file		*file;
+		/* each command gets 56 bytes of data */
+		__u8			data[56];
+	};
+	struct io_rw pad;
 };
 
 static inline void io_kiocb_cmd_sz_check(size_t cmd_sz)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1babd77da79c..1c3a5da9dcdc 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -20,14 +20,6 @@
 #include "rsrc.h"
 #include "rw.h"
 
-struct io_rw {
-	/* NOTE: kiocb has the file as the first member, so don't do it here */
-	struct kiocb			kiocb;
-	u64				addr;
-	u32				len;
-	rwf_t				flags;
-};
-
 static inline bool io_file_supports_nowait(struct io_kiocb *req)
 {
 	return req->flags & REQ_F_SUPPORT_NOWAIT;

-- 
Jens Axboe

