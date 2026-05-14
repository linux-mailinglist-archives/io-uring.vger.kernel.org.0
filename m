Return-Path: <io-uring+bounces-13325-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AKtpCdrNBWpGbgIAu9opvQ
	(envelope-from <io-uring+bounces-13325-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 15:27:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 75A58542542
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 15:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D3626305EF2B
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 13:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 909693B5F59;
	Thu, 14 May 2026 13:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="YPJYcVds"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EE13E0240
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 13:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778765071; cv=none; b=XXQ2V9Dl6sqCQwwEE+vznp0lPSUUEB3HD47kxm2Ce2Y5+1LYREI7+yLTjiNz8QACiDKV5jusxdlxxCGpD+KQZxxuw14+Svw+03HsunNHjR4NmfWw4dXxldeD8hJin6a3sWTuo+QzTYDfFATkPhygGp3zMGVyFIlHB7/UtVX00T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778765071; c=relaxed/simple;
	bh=0EgHAanl326zQmyhJFHTcII5GpaiS6mGvN0qMs9m+a8=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YpzLryz/BP2DxzYJ+AnRyUmwi1N0Yny2zg5GrOQxSH4i0rYsRvGeei1ypfv/D4PZGD3KLH8yg++NA8fOTk+ukOdS8IDk1lq1X1SP2I9gkyXk53GZV837JceXIIM71HlMIL5zTOIirtO/ml13z7BkD8h9WAMoioEsi+PYrAXn/Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=YPJYcVds; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-47cba53479aso4946021b6e.0
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 06:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778765069; x=1779369869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J5bPv/RQINZmZ+iPpuJUYm+JFqziC+vyfCkXvUxzB1Q=;
        b=YPJYcVdsuTci+CfeHRyYEyofrr73Ptlt2scS7laV+YSSJa45QBbZQ8aKuLpve23N29
         mljlaMYuYPTb0sV2zdLbhfyW/g0CM+hCKwUNt7WcHyrZuGBl5qwU2kmeVZTT8JUbT4RK
         +38VIozn+69iiNRhm8NyAlJ2T5j0GZ+K2YccE1h3CRJqMPoCgtwKXwZBbVK1Ko0TtTvX
         0jApyyvjBrcdTHIBonshizJ7623oa139vjwXkpz4KKKJ/J5SoaIEvJZyllDBG7+QZc5e
         ABm9n0Unr2o41X+ct+RjickfTAVpFi+gXhy4B9fbNxzJIOp+H94WvHFaHMzqYIzOrK0D
         YwlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778765069; x=1779369869;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=J5bPv/RQINZmZ+iPpuJUYm+JFqziC+vyfCkXvUxzB1Q=;
        b=ARiirQY8+eY3EE56m9GCqKAEUfOEP2a2R4u16K4FR5v6OR0zHtA93S9By1KvmGhjyB
         Xqp/1JjDcvNSy1GCPthLg79REQiC51h4j7gBv9eTsLkc43tAzaDe8kzfuFl0iOWP8FFP
         2cgc3Kkbu7wcehyWtmRljKEl9Oy5HWLFEKHj8jErzjg7lWUIyS3M4lZe3bXcOD/S2TLy
         b0P4IowAfhlAE3Vd685KfV3rjkMhygLns6P/q14xsWTeD26Tgyr3tk+stAUUk4E/XilI
         QJsj7fPagFPldtDLcsZL4sMkj8o/p3RP04d940gUppnO83+/p08jF9AF55Pa47cjqV2J
         TR/A==
X-Gm-Message-State: AOJu0YyiahYJRJpQCiPXvfBiFYFpKT8VXHBNKGjTutnNMFtjjr3ClufH
	u7DowD1nQu8sMWFO6kCANfi4mfjVy438V4oysvnrOLygdoogdseFwWVzXkraHRxecoBvRmZfs55
	9WDX9
X-Gm-Gg: Acq92OGhfbVF0hHa6x9qJeKYmB988rnUIjr1MexmGoKjf30Hanu0z1xiWOhtEfHlPoU
	0CrG4aO+r5hLFr/xP4O2wY38cEDZwKzWqPmGbpRjZ1XcTNhhUa92Bigchx7qurMZi2HzOqMfonR
	sdjPozpJsv/TRHMStcFoBidMgbrQP6TLZ1uW33JkAUmHDuclOLCpM1P/glwp0wDf57TWT94aSvj
	0yvpaCt9bNNYOvDKxa2SdRpt7/KhEVbjqZGqMU8En8NW3MfqlhqYYL3/M/B2ORJ08bjWx60tkPj
	J1/BojvCYL1TaF5BJE9r6tbxxoIjAaDbHqgeZT5tXd0FuYJBWibuO2BSAS43XvwbsjCj14R9Ent
	1mocBeiPaCa9TRBP50vLWh5yVsRg51oWzG8dMMpFwqCoUQFslpNag83vzDQT1v56M9W4S1zS0+i
	WZVJG4lRVJBphK6fbCB4JyafRt3dKWfRymNZvPlH6mOdyyBaSQiKXfaYYLpVztTJ6UGxutV+f13
	4w=
X-Received: by 2002:a05:6808:3023:b0:47c:3793:c588 with SMTP id 5614622812f47-482b2cb1474mr4514976b6e.30.1778765068955;
        Thu, 14 May 2026 06:24:28 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-482d3a35404sm1340027b6e.10.2026.05.14.06.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 06:24:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Yi Xie <xieyi@kylinos.cn>
In-Reply-To: <20260514083443.203387-1-xieyi@kylinos.cn>
References: <20260514083443.203387-1-xieyi@kylinos.cn>
Subject: Re: [PATCH] io_uring: parenthesize io_ring_head_to_buf() expansion
Message-Id: <177876506749.606809.6340802688553139691.b4-ty@b4>
Date: Thu, 14 May 2026 07:24:27 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 75A58542542
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13325-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action


On Thu, 14 May 2026 16:34:43 +0800, Yi Xie wrote:
> Wrap the io_ring_head_to_buf() macro value in an extra pair of parentheses
> so it is safe when composed into larger expressions, and to satisfy
> scripts/checkpatch.pl.

Applied, thanks!

[1/1] io_uring: parenthesize io_ring_head_to_buf() expansion
      commit: c84701cfc90a90a6a9dfbdb138706a6d79f5b186

Best regards,
-- 
Jens Axboe




