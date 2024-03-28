Return-Path: <io-uring+bounces-1306-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EDAB5890E34
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 00:05:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F2341F23DA0
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 23:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF04586269;
	Thu, 28 Mar 2024 23:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OzJ4X764"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B03A60260
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 23:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711667125; cv=none; b=jsfwGv7Zcf2D63CcRWKRB84rhEc2MF1Z1wvLKhhaAOhEg//ZmYTsi9LPtvmt04ZXgRM3NsNf1RvcoCFaiZlOqqKT4dIHuNkoqqEO8wBlQoclgT6tP9rrdvCBU2aJAJ1bk3QkJg37rrIK/cRrBKeTM25sTsPIInEclBhdSKDrf2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711667125; c=relaxed/simple;
	bh=upoegHEPOhnTtAIMqhTxXZdb36Jc5jk9yy0qJkcSZLA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XUwNCvr4kBXYLOxpY4J+0RQZhvL7jwMeL02eliVyQt/FjbNgXKhVO3kyfVRX734BmoZKzlcjrducHJyEMGzQNJeJlPZCOcoDWlRWg3D9HXNsBjGyul9mpEu2PmCZ+ZRv/ens5s5Y3tc5hsERzz0Csu8X9Em3WHhgobfO6/DdL/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OzJ4X764; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e6ca65edc9so373596b3a.0
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 16:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711667124; x=1712271924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gb/lqw0FtEKA4ZjWr924Ikq7h9RH/QqFlEqu3taDoiY=;
        b=OzJ4X764XaS2NF3zcWgQ14idfNlu0SVMkwlRPnxu1bajWE/WRF4X5eUeMDXVNgGIa9
         KzJZzKxJQMVxks+5SUNZTbNc0hgPI+jydO9IqPBSRkFlpETsfcaD6/i00a2kASY5BPzx
         CLBMj04q8NgjzZ2rUxplYy9YhVtFcD0fWbAVkP92mWh934LlOKbQXQWKMA3HJEID0nRU
         kjDXkxFG7upnsA+xWckT2YgVWhEC11yvN4h1sSlSzS9npMkPMvxYhyehz0FHhs9wgBw3
         fyq2f2LNkrUdw548xshRvBRoqeN2xbghfQznJlKpm37OGzw8LxP9r1jFh1cvDzpms0nK
         uaAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711667124; x=1712271924;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gb/lqw0FtEKA4ZjWr924Ikq7h9RH/QqFlEqu3taDoiY=;
        b=C8CYBDvXmVNiP5oCjHGtFmw1xjcR2xUJZ9Edjnv3mYNtznXEp0DsexR5ytXjG11+DT
         xfrmq3AYNvIFoqTbl1SXTnpHkpNrZKqtgfGaelgImMseWoXa4vHLF0vA8raNcEU1g3GF
         0c3lpc1zPJBof90nSrngo8deQyb4fuwFpvRTF1+u0O+s8mi0FkGPUuHue/QpCRLImiiF
         QZoVj3cv1Hn9LqSfmspIvtL9gnyvKb3sjJGEAbmE3Yvhv/juJH6lHG2RF/koLCcfm0ds
         BoxI9HvqltHvc3AeTuuMypCDnbfkxA8+oD9V9kPDzjk5KsRlvFj4EJ6ubjQJG7pFFPeo
         JjAA==
X-Gm-Message-State: AOJu0YwQRToN5SIYCTTy/an562GppN/IkbPIFBUXgL2LSvFxKTdWcjPD
	9GNgXMtfg8tVPkTD8XTR6nVFRqP98c69+23KZZ+FD7FSMek4JYjywsZwMFUJBrQ=
X-Google-Smtp-Source: AGHT+IETwdcPYHA8vhgIpuL+3aD0yyV0TaJIugVaJ1LvwXb5roJlbbb+zUwinHeFhRIkYjAUtZBz0A==
X-Received: by 2002:a05:6a20:728b:b0:1a3:c3e6:aef3 with SMTP id o11-20020a056a20728b00b001a3c3e6aef3mr714252pzk.2.1711667123883;
        Thu, 28 Mar 2024 16:05:23 -0700 (PDT)
Received: from [127.0.0.1] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id cx18-20020a17090afd9200b0029d7e7b7b41sm4013902pjb.33.2024.03.28.16.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 16:05:22 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20240328210935.25640-1-krisman@suse.de>
References: <20240328210935.25640-1-krisman@suse.de>
Subject: Re: (subset) [PATCH] io_uring: Avoid anonymous enums in io_uring
 uapi
Message-Id: <171166712200.796545.5071534678593541812.b4-ty@kernel.dk>
Date: Thu, 28 Mar 2024 17:05:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 28 Mar 2024 17:09:35 -0400, Gabriel Krisman Bertazi wrote:
> While valid C, anonymous enums confuse Cython (Python to C translator),
> as reported by Ritesh (YoSTEALTH) [1] .  Since people rely on it when
> building against liburing and we want to keep this header in sync with
> the library version, let's name the existing enums in the uapi header.
> 
> [1] https://github.com/cython/cython/issues/3240
> 
> [...]

Applied, thanks!

[1/1] io_uring: Avoid anonymous enums in io_uring uapi
      (no commit info)

Best regards,
-- 
Jens Axboe




