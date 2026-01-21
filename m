Return-Path: <io-uring+bounces-11866-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cMzjJc09cWnKfQAAu9opvQ
	(envelope-from <io-uring+bounces-11866-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 21:57:49 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BC045DB0E
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 21:57:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B6A6B78CE52
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 18:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9332C2EFDA4;
	Wed, 21 Jan 2026 18:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HaGdoHkG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f66.google.com (mail-oo1-f66.google.com [209.85.161.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C55332EC4
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 18:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769021513; cv=none; b=KnvQ6/925VFVBo9e4iznHiNwjlDpzlS18f1ufQtWuLOvvxLiCSjypmR4spkGnJcXGigTn/j1UVoxp+Fn6hr2TAg9IAyohjpeMTKQxE30Ei+XWPwOF5uG0lAjdrEk8l02QCRYwBf1fjfdgHq985x9VTM2uyUp4NJWHSPxAN1ZKPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769021513; c=relaxed/simple;
	bh=j81+srAOiz19ppIntfCff2emIhTZzYaA32LZ3ubsvmQ=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=trWG7OSkwq5nNkTTovsCeCe/sdpA1PAgqRTdNEhVoORiCNruqI9v4+zD8kzHrbINkVLc9YaWHmSXeTCUnyTyTyWol1V0og445l/UKceBVg81jUydcxATQ90ZrNeBCYienMpKjuG70GcDbSY5/W4dP2/NSSnKXrRVKk6K4AdxzN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HaGdoHkG; arc=none smtp.client-ip=209.85.161.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f66.google.com with SMTP id 006d021491bc7-66109b09b53so60068eaf.1
        for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 10:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769021507; x=1769626307; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n0unr0uqyrt7zZDSJKrLQFwmcBm9bPWqXNAFc2vS/zM=;
        b=HaGdoHkG0hHrUOgELFQ/v64ydHUoOfDoTozmizxV3M2b8LLeKsCF1UFb6VJw0Ehf9A
         vvG1hCq/3V/p2mhyeNwuKTU9XXpUg0J6+NNtc6qDPsGj6k9r6R8ONFeH3NmIxDtnVVD1
         vVKDFb+BjMnn9Cvtmd+asF3pfkBrM/vsRzCmv0Jetbebh1iEYqUlV+UA22eIrymrZQIB
         QnSBaWU2Wc8BWf1ZIxOrGsk64Le/VAIsnIgT+eU4rjNGjWXSEm7nE4X0Pjn/pXAlaQeq
         biJxdNhisnUTi5OcGmiXzS4HZq9KwFEH4URnsDXkj/YSgSBPY9S1EYb4iC+d4o0fLBQZ
         XVBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769021507; x=1769626307;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n0unr0uqyrt7zZDSJKrLQFwmcBm9bPWqXNAFc2vS/zM=;
        b=BmI+vH0XS1nE2JKBdduJO0nKA+9o+pdpiRG5g5XOz4O7dYpf+MhDhDK74m3Srp7bwl
         Fzv4CAsvhCwCLgkVcCO1yKAP4f7jT9wIe3Hcu1uI9fZqXVqV8D7jYFvVp19ni6r+JAWn
         pR+0/5Sgo6775oNa0h7E2QL9hwkf/8T9deF2z9eJBP0nxnc8GPuiXjNZ2JekFcIAkuTp
         I5KjJL/JNVDssrk9uudHBun3NiCp6hIUFbb6RlgiMX+f17nf7Il9UBDNR7qPxlluuGUY
         b8VVLMABhfVxCSicg3FzfmFguhiz4el+M+6xxiGHb/dIEWwzM5utXcHSRep+lxJmlpth
         oDXA==
X-Gm-Message-State: AOJu0Yyz8UQtO9qNdbD9XVSHdpfeeGft3G0OAuPTH/LWX1sZX4lkHYCP
	dM4SXaAfIFZCFon97IQz9JehyVWU8mh66wE1k8f9lcKJgKO7X4TaOag4B0QIWTrOD276B/aPLk8
	cE1A3xaYuVg==
X-Gm-Gg: AZuq6aK8EnefJwcPuxgiIxcNQzma41CAW7JB/eXDLGHEECGCeTa/Iyg3Gezy5DQymlq
	9PXaQ8zid6TS1+RMjPdMtSfuGu+xUYTwPvE+aJj7qssMkr4kBQ5RXa4IbSb/ST2lpNSuctJEt4I
	4kVu+qbC8SoGwC+vsQY02URxbMz9wRPmV9242SoWMCSQ510YC3GD1/xAz8YShjJA1J7L2zDlCHj
	QrNySVeYM4VjPHdtkezEscCPN429tqkzyHurPsnRVFE2HrysQwM97QscjSg6YkaEzJbpftm1P/x
	efVWpD29ZvGQOVX/1wF4+uEIGdoWR71dW1fDq85M9Q6sOXxnHvI3aKnsKgTTyP1IU80rNGWZzbc
	Pgd2RNFQtJcYqY8jck6y0OuDLz+xQrKowwy5GDADJAem/qz94WNcM9HeJHWulfnAFPWAbtVr87o
	AQPGC12zOOjpXu4wzGDDxVl5/nSbltIAxd5SqGqkUHC4UceqZEkwIk/Lds25PlwBr6aYTd
X-Received: by 2002:a05:6820:4611:b0:65e:eec4:6fbc with SMTP id 006d021491bc7-661179335a0mr6078710eaf.1.1769021507592;
        Wed, 21 Jan 2026 10:51:47 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044bd15c79sm11857400fac.10.2026.01.21.10.51.46
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 10:51:47 -0800 (PST)
Message-ID: <9f0a2238-2191-42e1-9597-a60684ff9634@kernel.dk>
Date: Wed, 21 Jan 2026 11:51:46 -0700
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
Subject: [PATCH] io_uring/sync: validate passed in offset
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-11866-lists,io-uring=lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,kernel.dk:email,kernel.dk:mid]
X-Rspamd-Queue-Id: 3BC045DB0E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Check if the passed in offset is negative once cast to sync->off. This
ensures that -EINVAL is returned for that case, like it would be for
sync_file_range(2).

Fixes: c992fe2925d7 ("io_uring: add fsync support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/sync.c b/io_uring/sync.c
index cea2d381ffd2..ab7fa1cd7dd6 100644
--- a/io_uring/sync.c
+++ b/io_uring/sync.c
@@ -62,6 +62,8 @@ int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	sync->off = READ_ONCE(sqe->off);
+	if (sync->off < 0)
+		return -EINVAL;
 	sync->len = READ_ONCE(sqe->len);
 	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;

-- 
Jens Axboe


