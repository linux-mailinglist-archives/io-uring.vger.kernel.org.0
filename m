Return-Path: <io-uring+bounces-12721-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GFS/ONu5uGnZiQEAu9opvQ
	(envelope-from <io-uring+bounces-12721-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 03:18:03 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 505B42A2CBF
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 03:18:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DFD443023DAB
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 02:18:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 585631E51E0;
	Tue, 17 Mar 2026 02:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CI/1F9aK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36841D9A54
	for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 02:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773713879; cv=none; b=bFy1nKGH+lBa4KIMX6XWZbyrCV89UYjQLNP5dyO9v5QdBeJPRkxwQWONmS4pCxx8VtqQQbrq8wHOYimAI2z4/pvHE27VIUSMdx89BJWxuegCaFzbjo8Hdb6fbF0rGghhDsY4y96stEjFUNr5Ph8VasR2m7cQWKmp4GbycJRsp2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773713879; c=relaxed/simple;
	bh=Gt4zVeLGfdDeE1PuP/xFlv46uN13Kz5rGB3zAFdg6HE=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=KoZILH7upWh0c69wVe9q2QUgkXj538k9TmYVGYPN3XwhePxvcEPGJ0V8jVJdcMf8jmXtACxxP5aoj6+Z/qrrPClSncAUtDu0Lhmjh/DfnULHpd/Hb6BDBwiH18vTA2Yt5jEYTlkF081iSw4JhoiqXWYossMNdUxUcR3sHKzJN5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CI/1F9aK; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-67bb4e8955aso3116379eaf.0
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 19:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773713875; x=1774318675; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SQDgpCAGuB4+zX53ymT3P5ltQyp0wKBgAtaGfwPIaOI=;
        b=CI/1F9aKLKudA1soVgpD3lWKR9/b4LYTFTzcz8ye5FO75U2rPpGL39SYgQ39S7LZfg
         hBejaL4Vt5CGQ2MWPEM1QxIbWPF0g832pjV0LXNQBJtwYdRcsAJ2nad2j0vHlY6ieCu1
         GxPD0cShIouX+9W4fXZYaSjkez7OD1UKDudLLCboO/XCIi2ssc1EUUpVh55vICtCFOmo
         jUOF1jWX245zTAjOSUoC/NPKWbUrN/wkzfcweoc6EnvIKAmRji1BuMLyzwMmmhupXp7v
         JDKaacaNj/oL0J/Mq6ZOfPXH2v4iZrficimxHP1dzXrzFLvXN9koYwp+YkWi0LJmOPRw
         I+og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773713875; x=1774318675;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SQDgpCAGuB4+zX53ymT3P5ltQyp0wKBgAtaGfwPIaOI=;
        b=lGY5zk8Xo35lV45nZ+yzKnvlI4zpOWLIB7Pbdi7WljBkWuCKfEyLM6WIv3e96zNh50
         EGGCpxBCrctA3sAck8KQPuqaIpOQ4oNFSG+ELcGEYqj+uMVkQJa0TqAs2yuIxJZWtogS
         3YZ81JZywaGFSeZwiAFJQG4vXoeRKouVwPqNwHZ4rEbLc9NaWDHZhVQZBidm6/mhoYfi
         tnqBxQ5d8843490xieIIh9p6ctEt+64O1VaIDbWMjvV6uIJ/64n+c8WV2+deAhnDgQp1
         ZWalJv937V+meyxuodtMVT9tYr3ndqLoNv3CBpArMsGt75AHofjiJJZz8QucNKtrSN8q
         4qaA==
X-Gm-Message-State: AOJu0YwGweKQpyhQuISZNIQtCMf2oF8Ry3ibsw9vXdvRnYmKMVPNkM+5
	mmFfbiYwDd9McS15MHwo0IAzYfn/VsP4E3Xxo95z1aK13pV+ytTquf+wFJtDdrnj7pWZNxUGjxA
	v0XU4
X-Gm-Gg: ATEYQzxGFGf3OTUQRafgodSw9zQf7wsAkKMNssFgJwDHdK2EtrBwfhP9QG7aoWaFUXm
	ydxU3VVZMTEmA9j8YL/DdNycrkquAAcGQXEZhf3GW1uve7A5eUYFBC3EbFVTume6mXqH6jsT0WF
	bLjK7WvDMlb77Pa3xFT/Vk943EWgxXf3fECBv9HxXkIAcpI4Fk5IBqE1P6Si1ufJs3zj1uoFYV1
	94hrDDO/Tr+TCQb+VqPjCbObfgFsavaJO7/8bTNNRHnwrRzO98R5JRUg+dlCypcCkw4pA1B2LGi
	mR9g9PKQNH0AuQH5qJrLBbG/H/waGKOoBnVxs+FXoj1bsqSjFmFub+Zb/jD1ZXPZcdZbt3cdKjp
	07GiHm2cDU1lxt0sBA9wIqFw5oheZlnHmP7wEGobySmByKZ8e4ULcjXbYCpKZZ0cku5EmQ6EEtG
	wMvbBiTivxAnk3gsmWGEihVwg4PGPLzQOx9ToIaBQ5+rneGxRv1RLbfe2CHxOS57jeEMGDU+Xtw
	abVdpBYcg==
X-Received: by 2002:a05:6820:1349:b0:67b:b72d:ec49 with SMTP id 006d021491bc7-67bda98df3cmr11247101eaf.5.1773713875429;
        Mon, 16 Mar 2026 19:17:55 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67bdd612b6esm6519849eaf.10.2026.03.16.19.17.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 19:17:54 -0700 (PDT)
Message-ID: <f39b5d6d-507c-4b2e-96e0-c5ba38aa2fe4@kernel.dk>
Date: Mon, 16 Mar 2026 20:17:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3] io_uring/poll: fix multishot recv missing EOF on wakeup
 race
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Francis Brosseau <francis@malagauche.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,malagauche.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12721-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TO_DN_ALL(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 505B42A2CBF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

When a socket send and shutdown() happen back-to-back, both fire
wake-ups before the receiver's task_work has a chance to run. The first
wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
When io_poll_check_events() runs, it calls io_poll_issue() which does a
recv that reads the data and returns IOU_RETRY. The loop then drains all
accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
the first event was consumed. Since the shutdown is a persistent state
change, no further wakeups will happen, and the multishot recv can hang
forever.

Check specifically for HUP in the poll loop, and ensure that another
loop is done to check for status if more than a single poll activation
is pending. This ensures we don't lose the shutdown event.

Cc: stable@vger.kernel.org
Fixes: dbc2564cfe0f ("io_uring: let fast poll support multishot")
Reported-by: Francis Brosseau <francis@malagauche.com>
Link: https://github.com/axboe/liburing/issues/1549
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

V3: split mshot and !mshot cases, and simply use the number of refs
    gotten in the beginning for gating retry. if one is dropped when
    we want to retry, we'll loop again as we'd still have remaining
    refs.

diff --git a/io_uring/poll.c b/io_uring/poll.c
index aac4b3b881fb..a264d73a8cbd 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -228,6 +228,19 @@ static inline void io_poll_execute(struct io_kiocb *req, int res)
 		__io_poll_execute(req, res);
 }
 
+static inline void io_mshot_check_retry(struct io_kiocb *req, int *v)
+{
+	/*
+	 * Release all references, retry if someone tried to restart
+	 * task_work while we were executing it.
+	 */
+	*v &= IO_POLL_REF_MASK;
+
+	/* multiple refs and HUP, ensure we loop once more */
+	if ((req->cqe.res & (POLLHUP | POLLRDHUP)) && *v != 1)
+		(*v)--;
+}
+
 /*
  * All poll tw should go through this. Checks for poll events, manages
  * references, does rewait, etc.
@@ -303,6 +316,7 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 				io_req_set_res(req, mask, 0);
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
+			v &= IO_POLL_REF_MASK;
 		} else {
 			int ret = io_poll_issue(req, tw);
 
@@ -312,16 +326,11 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 				return IOU_POLL_REQUEUE;
 			if (ret != IOU_RETRY && ret < 0)
 				return ret;
+			io_mshot_check_retry(req, &v);
 		}
 
 		/* force the next iteration to vfs_poll() */
 		req->cqe.res = 0;
-
-		/*
-		 * Release all references, retry if someone tried to restart
-		 * task_work while we were executing it.
-		 */
-		v &= IO_POLL_REF_MASK;
 	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);
 
 	io_napi_add(req);

-- 
Jens Axboe


