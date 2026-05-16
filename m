Return-Path: <io-uring+bounces-13373-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kI0XAi7ACGrh3gMAu9opvQ
	(envelope-from <io-uring+bounces-13373-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 16 May 2026 21:06:22 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F01455D720
	for <lists+io-uring@lfdr.de>; Sat, 16 May 2026 21:06:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C55543004DB7
	for <lists+io-uring@lfdr.de>; Sat, 16 May 2026 19:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5E48361DDC;
	Sat, 16 May 2026 19:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="c8r9nwQD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653AF355F25
	for <io-uring@vger.kernel.org>; Sat, 16 May 2026 19:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778958361; cv=none; b=Y0ZT6pBopvF92UsCliYuOMwb2FyUPuoQX+Sd3RX6GokuSHoku7US3KYodAZUxpcpYbC11vAo67IVQy6ZlJmXVI9JGyn1mrFPw4ON0r0MWJc4EBN8PyGdX3eQPrT9Ol4ITpmmwI/0uXC32N8YGEOA0W0kAKiZP4jO9ODlW+uBNlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778958361; c=relaxed/simple;
	bh=H1v8hiSujTN0uZjS5kUmvN1xFFGnrx/aq0tiUpBHd+E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=IPCYLgW1Oz7sWF5m+DuJWryT7Hwc63a1KE/1LlULURBqGeFJh8wkFz9OlUVMXoAuSISwDZ/11HkAJOOfTSseowD0FxbmMWO6aWdoFppVsI0VNQAGJIGEku4tAI93RNkY3G0WF5YTc5CgYwepxChGLD0qjUfBugbJL2febn5dPqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=c8r9nwQD; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7de44ed7a11so1138247a34.1
        for <io-uring@vger.kernel.org>; Sat, 16 May 2026 12:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778958359; x=1779563159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hCg2nDoT/7KdIN0atTPHQrr5FV6YL1prt6+sWTXtM4k=;
        b=c8r9nwQDTiOG4uQyA3n+lzE0498l5BKs1IgbkodvZqOJ+ZTxLuDzx3V5PArYBeqb/c
         pFj3njBWBgNRg5kLHWNtwkE4qOzvr9rdi+IoU6utP9na2EMOmeYfd3r0xTtbSPfnA62R
         wWs3SLl7LzKZo/VtMmlThWOkkQABzBnpfnxdssvNFXONlrJnMz8cS5IX5YgSy2o/Pxsu
         yi5fqSxrOc1MCI21rFnNvt0QfHGpEmxUQswL+mNfpUP6/JU5CtZj56c1fNQz/DEaRdQs
         joiyShctqBBCgLcC5ReMF8O1Q7ULdzVQi1vC2HwWTvSocg5oqQ3LAC0AlX+Fl+jkc39/
         JOpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778958359; x=1779563159;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hCg2nDoT/7KdIN0atTPHQrr5FV6YL1prt6+sWTXtM4k=;
        b=YzBIjzEUmJAqScvri6Vrqgkf9y5gdmZLSVR7yhJUUj5ECUwFjkOk1E//1dPZ9EkkNF
         /CaNLddgITIrB0dQawPjmoxdruBYPsUiw96yUVHv6Vy2koWRirc6QIyxuEJQfHQZP2yZ
         AudiJcIK/qqU+ZMKYWIETe/qf3EutNSSL56QN6KMnvm56Gx2nyM8Co+aky+qGXQlzwaq
         WClffwYF1XPUESyO+CqhAhQlFJqCw/0H2Jy25Ak+V4DOuG/7mJeNfX34NUOe8LpulU8I
         U06Wo6SGtMWn4K+o8tg6aNIlNYXH7ZxR7iWmvk71YSXOreD3O4ksa6xGQMqJJFMxvGOw
         ta4A==
X-Gm-Message-State: AOJu0YyFFFRibwiEG5+EabN4D0+smZBLbRRxmfSjTMo1GgYx0wbgrPA7
	1IKHl93TQdNR1/Z6Izyh7lz8SzWodNzUXa/1H4UuIT34kL09gt6J5O2+DKgdCoC7Sw8=
X-Gm-Gg: Acq92OFnlMzekiGAxwPwctuuzt6r+Y+d7RVPUPMiDxwc5N7RD9bg3Us7RUaHDNRpqVe
	4NO5t3xcA/3X2Uy8qVLtzULJdgqTPhyB202PDy+UshHJ175uInzBeS+ymtDl7M+iPA8CKP6KbJw
	XaCFTC4Sd3XXKVKaEKruZqvmBlXgpKc9E8wp5uFKb8VevIKvjk2DqNZwVXYn8N/2xsl77gCH+x0
	//S+BTBgFGaDk2IVgWoeyNdiZwqFHt8myS6b8M25R373e5NmmsBhwDCl3r1j/NItbGzUigDVWD7
	Fy1zfUUPmXkZ9eueZ/dkrlmLRq3hufQ0aAacjc0Mb/RuDNz3ezjb+lOGCCPQ443qvFBCR+GB/YL
	J2e8Ffx9Rr9nW2SKFdQxUDr03iI89pUqNmYRPOT1qxBlcaNjcTg7ZFu+Z7aaCTrwfO+Q2zVVmXl
	7sBdGLBQu6YhZSfdNdYRr/NxGZttnpFUlzd28b8rne/DJFQi92kOJD7+hM9GrPEX+Ow/PKbLogc
	X9N
X-Received: by 2002:a05:6830:6f48:b0:7d7:d60e:650a with SMTP id 46e09a7af769-7e4fa054ce1mr6867691a34.23.1778958359453;
        Sat, 16 May 2026 12:05:59 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e55bbd08ccsm4023092a34.17.2026.05.16.12.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 12:05:58 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Heechan Kang <gganji11@naver.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20260516184709.852814-1-gganji11@naver.com>
References: <20260516184709.852814-1-gganji11@naver.com>
Subject: Re: [PATCH v2] io_uring/waitid: clear waitid info before copying
 it to userspace
Message-Id: <177895835836.925638.10996898303585193992.b4-ty@b4>
Date: Sat, 16 May 2026 13:05:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 2F01455D720
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,naver.com];
	TAGGED_FROM(0.00)[bounces-13373-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Action: no action


On Sun, 17 May 2026 03:47:09 +0900, Heechan Kang wrote:
> IORING_OP_WAITID stores its result fields in struct io_waitid::info and
> later copies them to userspace siginfo. The prep path initializes the
> request arguments, but it does not initialize info itself.
> 
> If the wait operation completes without reporting a child event, the common
> wait code can return without writing wo_info. In that case io_waitid_finish()
> still copies iw->info to userspace, exposing stale bytes from the reused
> io_kiocb command storage.
> 
> [...]

Applied, thanks!

[1/1] io_uring/waitid: clear waitid info before copying it to userspace
      commit: 93d93f5f8da791e98159795c6ef683f45bd95d13

Best regards,
-- 
Jens Axboe




