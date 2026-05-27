Return-Path: <io-uring+bounces-13529-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QAQBC5sYF2pR4QcAu9opvQ
	(envelope-from <io-uring+bounces-13529-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 18:15:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DB335E793B
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 18:15:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 03D7F3039C31
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 16:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F823128A3;
	Wed, 27 May 2026 16:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="O1aMiL1o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE4F421A08
	for <io-uring@vger.kernel.org>; Wed, 27 May 2026 16:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779898011; cv=none; b=lVmKIOVUzp/ukBnqKFvw8f6aWm23CWtTJ4edzAR+T0/g+AbNqWUpXTteIrhHnBCJ5CFqJJ6BGrpUf0HIxN38Lmcwv6vuFPBSRiY+LcfuIqwHRx8huDehGwKaU7yAH/0eJBI1hiNtgITacyL9N7qAJLekUXr326/52TX9GX1t6pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779898011; c=relaxed/simple;
	bh=fwkxSqx7ty2JQSbgYGjXCJheNp4aXVJfNCMAJtiBUtE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XnoWxVLdMLicCBhbiCyyJQ+hJ0Ie3EmBDwD7cFmhB6D4Q2xOLzouvxRgOlyOFIz5eSLGWTettd/26wOU5Z5SKy9NsmL5FmSvAeuVtn2VIbzQk/CqhbOa18Z8GDxFhGjn9C8jv0syLTAKhv1erujTz8spaAXVvsG94OutI2r8/hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=O1aMiL1o; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7e603d0ee0aso3333946a34.2
        for <io-uring@vger.kernel.org>; Wed, 27 May 2026 09:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779898008; x=1780502808; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DDewevQlsNX9Nf5an4WdPkqFyUO5oYIAKU8piRx5pII=;
        b=O1aMiL1oIFen2XoIfw6SCJALa8Ot1OyXMqMDB/oU7qEd7xqcpJcmD2Obpa7Xhf18Wb
         Tv/hwDlI7f60fJZz3LA5WSK4ha8sHBqy0Kfvy69FTonSDHkqHImBe3jY7r5kUGVV69g6
         DhgWZzngjuvHdU+DNARaOlOBOOyKC+yJ6iCMDZXnpaxkUD82iSBKl0+T6BjDJfWzZiQg
         6B27azfpAuiutURWisO1EMMtvonRee30OHl5YFyTxvXi+wBdj4rE79r/FP+yG15cxFY8
         kseLG06/4whit0X1Jj2asavVTSHHe2CqrCILfrcIu8BMz8zsF0kxznceQwGoyP4Yuqbv
         9JUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779898008; x=1780502808;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DDewevQlsNX9Nf5an4WdPkqFyUO5oYIAKU8piRx5pII=;
        b=CrkezwrWap5WonYApSlQSm0W5vilcU1kU2Me+1GiZPKZMv6kpEVEOJQ0qCY6w8i/5e
         HWELOpPaaK9XYLFzqJ9/Zn5y1kAjhUcJPQ0vRGgNPFBGt5hcEZQXlkZ0BaxGYsjXrrIR
         fp+Do297f+OrJ7Ugu+e6cmpgIBojaghAPZ0lWxLVy7bB6XfHQMdyHDQzHKmLnf6O7UVW
         AIB5vH7QzqhNPMo2o6vNDI2yX40cmw8aHsB1evsUrjob0QjPE7HzGoxA2zJiw2LxRr0w
         8dLydiBSzaJBboLCBMbyNJLWG9AceD5dIq76sBaY3AmZwODMg2uJUsjuCgXflWGIptqC
         H1tw==
X-Forwarded-Encrypted: i=1; AFNElJ8iJxm7K0HDBqJ6HAS0aC5ttu7SsfV5RusS+81fDiE0XPsdCk+vn4tIzU0UWVQS/0al9mKAdv37Bw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJifKdHr0evaDuiWieZAf4JuQ9b1BSMNo6ans2bsU1GTO2qtTZ
	VPvc+E0NE6FR/F3zF4ZMXrYm2s8ujhmFkq6stAMIq9VWdqYpwcHg4GTdmMNE3vVPuU7N2loZGkj
	2hWIVr5w=
X-Gm-Gg: Acq92OGtWn7IErV2TP+g1D7zCH4jZ4SIdewq+ZQ7VhFCHZmw8AaRH05PSrOt/F6f63p
	4XLnxuGi5G1Ikbul+vohKl+n1sYH2rDCTUb84BL35rc6MvUuxyw0gbGIS/OYwEGADrNEtb7vowA
	Hp2Fcp6JmY5GbBgi3J86RurqvfVZ34zeUj7YEK3B80zuFGXOPl2mEX4xFWv7rjyEs7PwzoRkMSb
	Kc9Rxksm+WttMEvuc/5Zpf3QZmI+E2RDT2fU0NvWe0/D2kGbCd/kp9Qm890/Fd9oYqonpBiHLs1
	KoX6SzmNfgaS5EHOSz3DAAsr99kTRJbNgYrieTgC+cDye+e49adzmkVw3hCLgVj8XCaMkml8Upt
	ynxWWNBSJrGqs7FHbcdMbXow3ekhHbLdr0x8uYdG8tMXfc1Q36H6Vl8T1T/HZAOy6diw3kUVvgR
	7QKIfwz+oLagXvvex9Wea0IUwG2eLxTN98nSlkmolnnZeYx1rFQJb4CiC/K+yjh2YT+6iZIozNa
	61G7YrMwm9s+4TIcCM=
X-Received: by 2002:a05:6830:6682:b0:7dc:dd58:50a1 with SMTP id 46e09a7af769-7e5fee5ef73mr15600883a34.15.1779898007969;
        Wed, 27 May 2026 09:06:47 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e606459bf7sm11606383a34.1.2026.05.27.09.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 09:06:45 -0700 (PDT)
Message-ID: <ee931505-64a2-411d-8607-3db8912b70c4@kernel.dk>
Date: Wed, 27 May 2026 10:06:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: bsg: copy uring_cmd payload to prevent double-fetch
 from shared SQE
To: Rahul Chandelkar <rc@rexion.ai>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260527105931.3950913-1-rc@rexion.ai>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260527105931.3950913-1-rc@rexion.ai>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13529-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: 2DB335E793B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/27/26 4:59 AM, Rahul Chandelkar wrote:
> scsi_bsg_uring_cmd() and scsi_bsg_map_user_buffer() read bsg_uring_cmd
> fields directly from the shared mmap'd io_uring submission ring via
> io_uring_sqe128_cmd().  On the inline execution path, io_uring has not
> yet copied the SQE to kernel memory, so a concurrent userspace thread
> can modify fields between reads.
> 
> cmd->request_len is read for the bounds check, for the cmd_len
> assignment, and for the copy_from_user length.  A racing thread can
> change request_len between the bounds check (passes with <= 32) and
> copy_from_user (uses the enlarged value), overflowing the 32-byte
> scmd->cmnd[] buffer into subsequent struct scsi_cmnd fields.
> 
> scsi_bsg_map_user_buffer() independently re-derives its cmd pointer
> from the same shared SQE, re-reading dout_xfer_len, din_xfer_len,
> dout_xferp, and din_xferp, enabling direction confusion and buffer
> length races.
> 
> Copy struct bsg_uring_cmd to a stack-local variable before use in both
> functions.  The pointer variable 'cmd' is redirected to the local copy
> so the rest of each function is unchanged.
> 
> Tested with KASAN on QEMU (virtio-scsi, 2 vCPUs).  Without this fix,
> a two-thread race produces:
> 
>   BUG: KASAN: wild-memory-access in scsi_queue_rq+0x4a3/0x58a0
>   Write of size 96 at addr dead000000001000 by task poc/67
>   Call Trace:
>    kasan_report+0xce/0x100
>    __asan_memset+0x23/0x50
>    scsi_queue_rq+0x4a3/0x58a0
>    scsi_bsg_uring_cmd+0x942/0x1570
>    io_uring_cmd+0x2f6/0x950
>    io_issue_sqe+0xe5/0x22d0

I don't think this is the right way to fix it, ->sqe should've been
stable upfront if this ends up happening. Can you share your poc with
me? Your trace has been trimmed down way too much to be useful.

-- 
Jens Axboe

