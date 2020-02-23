Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F45169662
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2020 07:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgBWG00 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Feb 2020 01:26:26 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34883 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgBWG00 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Feb 2020 01:26:26 -0500
Received: by mail-pj1-f66.google.com with SMTP id q39so2652394pjc.0
        for <io-uring@vger.kernel.org>; Sat, 22 Feb 2020 22:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cc4oXFXL7cWe6TrANek4Cb/ppJrqrpt5yQ8IP5492Gs=;
        b=BYbnMMlyZ8ayu5CfFrkfml3saLhzzfgCWCdu28VS6RD8PocNT4tVUWmapPd74CL6XD
         Jrf3SxPkFaRtI2pvhBsMw8X7/CSqAQYLT3SFeDEgw5n6LDgQYpPFHJGzHwXfgOo8TLTS
         5YpYGz9z44PwasqstwRyxWDm+ThrFsA3gpkEEDYGCWniw61/Sgg8gcuA4JRcXp6dQV47
         W4rq7wH4qgGslZubud9MuGnZn65tly9KeC95Uk50WZ+FzMnq7HDClB/XigXQdFuLlDLV
         r7WqO/BYCLGNocZCy1XGWS1A2JbbFPjoZ7wi5EKlv0jFYmei46dJ1rch1mwZp3XUd12V
         rRpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cc4oXFXL7cWe6TrANek4Cb/ppJrqrpt5yQ8IP5492Gs=;
        b=APMf3L3/89BCAwboHPLSdJVOzxOB6TOM61xdq+IFa3gn0PfUf0c/PBXiwfI8gafjoI
         Q+drAZ33Tgaq9GMGxWCEzQNHQNsyjSqsAVzR56gc3YQE0PBuGtSAN4/hLuY17g95m2x7
         +oly7bofr93RCRatEs/XYKp+6XL4nIYbSc0YV/VnJKGoPPV2klKI0uQ13cGA5ODes9I2
         d3nwwad2Xa3THsL7fYn14AvZiW4bG06KHmjpcNlZ7IDkStAauU62Z3hk8rmocSjhl3Kr
         5i5AIevExNQ5O8irrg822NNWDOUNBsZXqxtzp6kbQyPDU/ckJI1YWnpqpPiNem9YBxV/
         +AXA==
X-Gm-Message-State: APjAAAVt6m0v3KvTwQnd06bLDf31jy6iFfpYMDVa01nzVsVuOOfsOaw1
        23c1PZUWpMfgNIqAr1CLjh1UnIHAjB4=
X-Google-Smtp-Source: APXvYqxAPm2cLlUIdqZ8WOHaXdvSS8DqHG+9He00E3Mw64CL1TyN9CWvIAk8JarI9PcHZBI62NwtSw==
X-Received: by 2002:a17:90b:3cc:: with SMTP id go12mr12979353pjb.89.1582439185553;
        Sat, 22 Feb 2020 22:26:25 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z4sm7870650pfn.42.2020.02.22.22.26.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Feb 2020 22:26:24 -0800 (PST)
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
Message-ID: <231dc76e-697f-d8dd-46cb-53776bdc920d@kernel.dk>
Date:   Sat, 22 Feb 2020 23:26:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <08564f4e-8dd1-d656-a22a-325cc1c3e38f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/22/20 11:00 PM, Jens Axboe wrote:
> On 2/21/20 12:10 PM, Jens Axboe wrote:
>>> Got it. Then, it may happen in the future after returning from
>>> __io_arm_poll_handler() and io_uring_enter(). And by that time io_submit_sqes()
>>> should have already restored creds (i.e. personality stuff) on the way back.
>>> This might be a problem.
>>
>> Not sure I follow, can you elaborate? Just to be sure, the requests that
>> go through the poll handler will go through __io_queue_sqe() again. Oh I
>> guess your point is that that is one level below where we normally
>> assign the creds.
> 
> Fixed this one.
> 
>>> BTW, Is it by design, that all requests of a link use personality creds
>>> specified in the head's sqe?
>>
>> No, I think that's more by accident. We should make sure they use the
>> specified creds, regardless of the issue time. Care to clean that up?
>> Would probably help get it right for the poll case, too.
> 
> Took a look at this, and I think you're wrong. Every iteration of
> io_submit_sqe() will lookup the right creds, and assign them to the
> current task in case we're going to issue it. In the case of a link
> where we already have the head, then we grab the current work
> environment. This means assigning req->work.creds from
> get_current_cred(), if not set, and these are the credentials we looked
> up already.

What does look wrong is that we don't restore the right credentials for
queuing the head, so basically the opposite problem. Something like the
below should fix that.


commit b94ddeebd4d068d9205b319179974e09da2591fd
Author: Jens Axboe <axboe@kernel.dk>
Date:   Sat Feb 22 23:22:19 2020 -0700

    io_uring: handle multiple personalities in link chains
    
    If we have a chain of requests and they don't all use the same
    credentials, then the head of the chain will be issued with the
    credentails of the tail of the chain.
    
    Ensure __io_queue_sqe() overrides the credentials, if they are different.
    
    Fixes: 75c6a03904e0 ("io_uring: support using a registered personality for commands")
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index de650df9ac53..59024e4757d6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4705,11 +4705,18 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_kiocb *linked_timeout;
 	struct io_kiocb *nxt = NULL;
+	const struct cred *old_creds = NULL;
 	int ret;
 
 again:
 	linked_timeout = io_prep_linked_timeout(req);
 
+	if (req->work.creds && req->work.creds != get_current_cred()) {
+		if (old_creds)
+			revert_creds(old_creds);
+		old_creds = override_creds(req->work.creds);
+	}
+
 	ret = io_issue_sqe(req, sqe, &nxt, true);
 
 	/*
@@ -4759,6 +4766,8 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			goto punt;
 		goto again;
 	}
+	if (old_creds)
+		revert_creds(old_creds);
 }
 
 static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)

-- 
Jens Axboe

