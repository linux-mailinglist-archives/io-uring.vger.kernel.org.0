Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6633416982E
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2020 15:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgBWO7D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Feb 2020 09:59:03 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38571 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWO7D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Feb 2020 09:59:03 -0500
Received: by mail-pf1-f195.google.com with SMTP id x185so3933086pfc.5
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2020 06:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2oyQ3Id6346ciahZpKd06XabSRnjR5pc1pPJ6MHDeA4=;
        b=V5aqM40ittiRlsVs9P5HCWJHUY71aLUY36aDVzRHIkoLBCygWrqacRsxKRbrHQyNYf
         sKuPFtc3wBdxrZjgAbe4uf7B+WeWrEMU5LAoGusLgww0cT5PwFwo5o416/zj5xnHdo+5
         EwSAT9X7FRIO0iqr1nCXtc04GOIt6O4ZDRPKEdpfEy0Djzvdxdi5TWnzQLd99u1GnC2h
         RVNEQ1iTEo3kol9nPxxYUqdfjxsuD5z97H/XW+0mb3VizDBleNv/ErtuyGg4IPwRkcQX
         F0hY7ISFb8QhL3NA+E0m7knn/ZvyWZq38O8Hp9A95NgnH6kKFzaopPVxFoNJfjWU+ZT3
         WINg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2oyQ3Id6346ciahZpKd06XabSRnjR5pc1pPJ6MHDeA4=;
        b=fl/XXx2UgEqJ09UmETqBnJrnAGE1j780wMVPpO19lUfzla2fmrpJbTXch2Rj0rGWvw
         wl2SgPFfMR9D/Vqd/Fv0yjrXieL5jLcS+2eVvoIGIoCI+H4ShMbzV9O9O7o2L11quIMZ
         HN7pLPWiOcarkfaOv7b3FXU2/J2yKca4auG7JufPfDV+ce3w0CXlPwHYqgmAiO76LqVr
         /0JFD5UeY4qPWvyyjE10UKJmwYCeK2M6KFTTnBp1BxH2K43+atwqwY3ZgzLFBShfvtVm
         2qL8FwBvKl7J5h7+5vC3VXst1ZyTKXZZHEwB0gW9fahwnQMboRM22WgL1+gXgeg3CIgQ
         4OPQ==
X-Gm-Message-State: APjAAAWpA/AYIiJKXRnE4tSzyFClREbS0yyp5Fc2gI706vRl4JQHMl6U
        yokaXN/mOj2gVAYQAPxGM2PFTw==
X-Google-Smtp-Source: APXvYqwGvqcX9izIG1rfRuu8QBofPIv3E2AsQ8T5d56qoq1+GPIbzZ/lCSxmHad1MV+f7NuoYREUAw==
X-Received: by 2002:a65:68ce:: with SMTP id k14mr46683132pgt.336.1582469941507;
        Sun, 23 Feb 2020 06:59:01 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id i3sm9327362pfg.94.2020.02.23.06.58.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 06:59:00 -0800 (PST)
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org,
        Jann Horn <jannh@google.com>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <862fb96f-cebe-dfd8-0042-3284985d8704@gmail.com>
 <3c9a3fca-a780-6d04-65cb-c08ef382a2eb@kernel.dk>
 <a5258ad9-ab20-8068-2cb8-848756cf568d@gmail.com>
 <2d869361-18d0-a0fa-cc53-970078d8b826@kernel.dk>
 <08564f4e-8dd1-d656-a22a-325cc1c3e38f@kernel.dk>
 <231dc76e-697f-d8dd-46cb-53776bdc920d@kernel.dk>
 <fcfcf572-f808-6b3a-f9eb-379657babba5@gmail.com>
 <18d38bb6-70e2-24ce-a668-d279b8e3ce4c@kernel.dk>
Message-ID: <3d4aa255-f333-573c-e806-a3e79a28f3c6@kernel.dk>
Date:   Sun, 23 Feb 2020 07:58:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <18d38bb6-70e2-24ce-a668-d279b8e3ce4c@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/23/20 7:49 AM, Jens Axboe wrote:
>> Anyway, creds handling is too scattered across the code, and this do a
>> lot of useless refcounting and bouncing. It's better to find it a
>> better place in the near future.
> 
> I think a good cleanup on top of this would be to move the personality
> lookup to io_req_defer_prep(), and kill it from io_submit_sqe(). Now
> __io_issue_sqe() does the right thing, and it'll just fall out nicely
> with that as far as I can tell.
> 
> Care to send a patch for that?

Since we also need it for non-deferral, how about just leaving the
lookup in there and removing the assignment? That means we only do that
juggling in one spot, which makes more sense. I think this should just
be folded into the previous patch.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index cead1a0602b4..b5422613c7b1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4923,7 +4923,6 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			  struct io_submit_state *state, struct io_kiocb **link)
 {
-	const struct cred *old_creds = NULL;
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned int sqe_flags;
 	int ret, id;
@@ -4938,14 +4937,11 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	id = READ_ONCE(sqe->personality);
 	if (id) {
-		const struct cred *personality_creds;
-
-		personality_creds = idr_find(&ctx->personality_idr, id);
-		if (unlikely(!personality_creds)) {
+		req->work.creds = idr_find(&ctx->personality_idr, id);
+		if (unlikely(!req->work.creds)) {
 			ret = -EINVAL;
 			goto err_req;
 		}
-		old_creds = override_creds(personality_creds);
 	}
 
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
@@ -4957,8 +4953,6 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 err_req:
 		io_cqring_add_event(req, ret);
 		io_double_put_req(req);
-		if (old_creds)
-			revert_creds(old_creds);
 		return false;
 	}
 
@@ -5019,8 +5013,6 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 	}
 
-	if (old_creds)
-		revert_creds(old_creds);
 	return true;
 }
 

-- 
Jens Axboe

