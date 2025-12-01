Return-Path: <io-uring+bounces-10871-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F737C98FC0
	for <lists+io-uring@lfdr.de>; Mon, 01 Dec 2025 21:16:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C539E3A3F8F
	for <lists+io-uring@lfdr.de>; Mon,  1 Dec 2025 20:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 902AE24A063;
	Mon,  1 Dec 2025 20:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DfH3uIYW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCEDA937
	for <io-uring@vger.kernel.org>; Mon,  1 Dec 2025 20:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764620194; cv=none; b=e2hytDLz6ztygQcunQAHBeJsS6zOWxfvqnpj7BT980fVv0Iy4WhGWy7Cjrf+v86REBCBhTgVmXnAlgwv2oReJNBBpHt6/P+OG5ejxiueebSUhLnu1gt3uBYb49wLe8witEE0xRPJsIo6MrzTWofZ9qtyhfUb/rcrD4fHJBCbxbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764620194; c=relaxed/simple;
	bh=VhFWams7lyRPZDIuIbaqXkF7PZRFGSeCxPXAZ364irY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uJ/tU2mccRqQEl7rH7Djds1DqrWawDWUMEOlXrzjXayHKlVL6GoCBwVn9u17AtT6WHrOd0Ybj6gjT/iESQMjIBRiMNJ9qfUNewZNgMP6MvCPeiT6sDGs+XeSglQM2nWAv9gmWoDmjsAx/bzDubgrkGnr0h/mzVziXXtP8aWwdXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DfH3uIYW; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-657a6028fbbso1816193eaf.3
        for <io-uring@vger.kernel.org>; Mon, 01 Dec 2025 12:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764620190; x=1765224990; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j+Oa6MGzXGAuWxl8ZtgkrmtT/6nIVLT37/yjMN3yRqs=;
        b=DfH3uIYW//DXmPIVCaHmePBSitE5NXIHhDSflPjKVbGhKx/Jh6XE9HbwJHER3IXRkU
         TYHxJhHYcPR+xtWs/vlG4yL6rqQoGEzBCNAp98wcqqJj0X+FjjrJ8dqhLGbPMVyGhg48
         Gn0D5iuosLG7aeqR9zGXw5LdpOZbl0/81FwZdoxcSd5lquOtWffq4LhX/wbPEPKqJ/vM
         ummAsm+bP53awPqTtPimsOorx/XP3aWMwArJ0CxXF1UqoE3wFDOabwSkb+NltvFIeTHu
         KnvCyrQPqEZi5Gdcral/hSVeyLnCESWVsq5nS/XwJ8kHlIps4r/SpSqBVZh5pUJ+2YMp
         XHQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764620190; x=1765224990;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j+Oa6MGzXGAuWxl8ZtgkrmtT/6nIVLT37/yjMN3yRqs=;
        b=b/4+RoMh1ihqHYN1X4CdcqLKROsNF+5vcK/pRGmnZKjVbuT/MM0CLz0g5SKPudyvxT
         wWIIArRNjm4QV/AVmoKFIYvYD5M4UNEVoQKKUmSO35RdcsN//6Ciz5xBeKOW0v1aZvCb
         gMpCB4cW1yHGvi28XF8F3emnJuNIQjBrHn+btpSrXBPz4uaKRRZ1pPdMF/y9i8YruDQB
         2h/XW+SjzzvxnLVKfoGSxcUrbrU2/5supxrzu0oWYMRNhl3zJlu+mEPWEMlLrefd+Zhv
         qQgNSHYMZ+JCEQQGpAr6LTge4i6Dn+fRGc2bIRWJf/bNayOjDuHTXGRWSYIudb0Y4eph
         Zu9A==
X-Forwarded-Encrypted: i=1; AJvYcCWRc9dgwk/x2Mn0zuaEJbx2TsvNAXMANntKerK9M5p6ep1fM9uFyuz9nKc0i27pLqQudVZ+QKb7kQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHCcVPYnnLZYQ5j4y4lA9FysuGE9RPeVdHFSbDNsyvLuq9iAom
	T0jNdhIW11GU/Z2pJfOMo81+QrmEZ6OpQdQrOo6RckFhOz/T6acKmfudgDcfH1VWBYbJA6p8r75
	Crojku9M=
X-Gm-Gg: ASbGnct2jvOypRIQw1FVlSwOOXH05LL+5F6DiV3N15mLMujhPapep+IIRqqF05mZF7B
	9tMRlqEegefsMd5yXszBhOTCLquY8kBdoaxuUX4NWcU48X50BQatXNFrNQK5WuO7l+9pKf3rSMW
	LQfQZjeBOrB6NiT0JCc6hb2lfw/E8OmtY6GpN7+4MCWe20gjrwua2IQyd7MUPZOZ6XpFQ7BBa8k
	f82orj5KLKq9Bt09hnJZFS5qjVUm5mkAsT0o5QJYsVGlnh2qs3Lx2ymb2HCXCoVTD0OhveAPZ8W
	EFbSoYJnOCEG97XAyxj92x/QGctfFKYSTv3JDGKkpIacU5LC+A5V3FjHtggOGzXqZN8o+VKNm94
	gJqYx8nu001ShKiw+TaQqulbBW0lwLNkbUS+SHivVJz9eSZIU6AE7rmsWev52PcwiMZkCjVWQgb
	2I1bz83Lb3vpu/gbIc
X-Google-Smtp-Source: AGHT+IEdqlPd+ymzbVDWhsjYlfK79/tgshfjPT6Q5sbzo9OmFt1D9j8HT9Hwl8Q4Pk8B0XIaZOSK1w==
X-Received: by 2002:a05:6820:6ae1:b0:656:9202:58ca with SMTP id 006d021491bc7-657bdb961c7mr10866619eaf.3.1764620189674;
        Mon, 01 Dec 2025 12:16:29 -0800 (PST)
Received: from [192.168.1.99] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-659332dff05sm2958698eaf.6.2025.12.01.12.16.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Dec 2025 12:16:29 -0800 (PST)
Message-ID: <6fcfa902-5d59-4d2a-9fa6-ea59529f6710@kernel.dk>
Date: Mon, 1 Dec 2025 13:16:28 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] memory leak in io_submit_sqes (5)
To: syzbot <syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <692dcb58.a70a0220.2ea503.00b5.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <692dcb58.a70a0220.2ea503.00b5.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git v6.18

diff --git a/io_uring/poll.c b/io_uring/poll.c
index b9681d0f9f13..5df09e4e958d 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -922,6 +922,11 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 		goto out;
 	}
 
+	/*
+	 * Set cancel res early, so io_poll_add() can overwrite it, if
+	 * necessary.
+	 */
+	io_req_set_res(preq, -ECANCELED, 0);
 	if (poll_update->update_events || poll_update->update_user_data) {
 		/* only mask one event flags, keep behavior flags */
 		if (poll_update->update_events) {
@@ -936,12 +941,12 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 
 		ret2 = io_poll_add(preq, issue_flags & ~IO_URING_F_UNLOCKED);
 		/* successfully updated, don't complete poll request */
-		if (!ret2 || ret2 == -EIOCBQUEUED)
+		if (ret2 == IOU_ISSUE_SKIP_COMPLETE)
 			goto out;
 	}
 
-	req_set_fail(preq);
-	io_req_set_res(preq, -ECANCELED, 0);
+	if (preq->cqe.res < 0)
+		req_set_fail(preq);
 	preq->io_task_work.func = io_req_task_complete;
 	io_req_task_work_add(preq);
 out:

-- 
Jens Axboe

