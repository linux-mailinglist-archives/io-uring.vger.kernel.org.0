Return-Path: <io-uring+bounces-5165-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44E279DF737
	for <lists+io-uring@lfdr.de>; Sun,  1 Dec 2024 22:47:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 584B3280AC0
	for <lists+io-uring@lfdr.de>; Sun,  1 Dec 2024 21:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEB72143895;
	Sun,  1 Dec 2024 21:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Wvkyx/6W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D8C18AEA
	for <io-uring@vger.kernel.org>; Sun,  1 Dec 2024 21:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733089625; cv=none; b=pl4OEd43gCpBVaDkhFtGpvJfzWpLZiucP16FisKoAZ8IIQPYv2CHZOy2dZmGXNL1SX+KRTcBvd9IkwhLNBO6QWudKeCKXG+1wB5cy231QPO2rdQLH5vW+o8mgg1sR3QN/PCvOqtT05cTPTJhiJ68Mxp63VN2uVRaJint6MueH+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733089625; c=relaxed/simple;
	bh=XNnCnhnSBLEIotrmWgrY0rC6RFzq2loaqwCAhUknthk=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WjBaGA8GDq7dCsticwq/OtjxwFP8GO97MoxpPiCs/LmNNZktVJVSlGf1mGp2eV+LLqOjnTHuNz2LZ/8C6k83XjUwlyOZNmk3PvvoZ6hJRyrUU57Tclv4yDj2o5kiqm+NwBK8nb8E3JBaMzmvgc+hgn0T1Rsiyy2PC9q03Pu+Pd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Wvkyx/6W; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2ee8aa26415so949050a91.1
        for <io-uring@vger.kernel.org>; Sun, 01 Dec 2024 13:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733089620; x=1733694420; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3jQ2ZOXhv2r48Tgku1FmjAs+Y4GtLo1F0PG8V8ctZAM=;
        b=Wvkyx/6WdoMnpToT8Ryg8ouujG09XJSAWCNKTxcwyKv7L+n14nCBy/eBNY6mMo4WE1
         yFpyYwlqVUy85YVYucNZNtVEU7Ao4XJ21SHuOhm/ga8mnbqe2/PCFGsQcu3pQ4Wm1TWu
         6WWncDQjp18qKrNo+TvolFT/ILFtIvcOkh8vD2+ca4oDWol8NFCwBrG5sAJ0/XFcJeEQ
         KRA7oA91Qysxz0ZtBXdosucTN0DC6SbAqONQt2cNpGMybKpW2DmnlrxK2FzQxxiPcfiA
         zt2ykRwKVRQScdjs9gdkwf3WunO5OiO/NPl5Fu2kpiIHh5DejnkMINx5bFZx5hHE5cZe
         6PBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733089620; x=1733694420;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3jQ2ZOXhv2r48Tgku1FmjAs+Y4GtLo1F0PG8V8ctZAM=;
        b=YhyhUuF1yhgQL0ezSqiHXV/WcOlNbWfTuOD6R9lbPhVYeemBx8Md0ZkmpdFDrZ3wbW
         GFVF248blMhuFKhq5KmF560l0C6um1woQroKgEk9LhB6luQCGkUadF/qbvdD3bH+Zo2G
         rC7wQefANTYa8TtLWWlrfnqu1YHgQvM80LnE8q5mcKJlgkIhTLRKavsma4FGrQ5cu8E7
         XDa8MQAjE61BfdAxgn96nwUAUKdRewc9aigACJebWW+gHTu6pX0FMAZ8najR/cRyfWaG
         7xJGggSNLB8qJtQTfuh53ohrDMLUA1YADGfOLlDjiqdWsZMes3Hyw7uJya8F7gyEfwyk
         eCcw==
X-Gm-Message-State: AOJu0YyjerPHirwgw1HxcFo1zQGZ1jJsWa+41Irb7//BugIdbFmmQDIJ
	IZespvMfdFaNsQUqXOS07MX/b9T0EbK5wW0B65SbYocIkZ9v1DfsiR/yS1rD0GLVuS77FZka3us
	l
X-Gm-Gg: ASbGncsRn/fOmxNEj2pVEdz2HIT9XWv181u+BUimsqnQssQvsturW5P3hv7OTJB6qMz
	1RZlbkrKwY/+K5UPsO/3amtXF6erCeIJEEFFhUjhRcsx5lMYEpFqj/GC5byH4mloH8JHrkQ40ZI
	ze8NCiUTimnlPzpnwqEvyydHMOEdtl+LITbVaO009ZtOaIb9U7/ltuFrHdmnGi48PLHobx5h9Ec
	D4H0O0ARac3z46uKQqFpzNanxfhT2c/PruCmU8iAw==
X-Google-Smtp-Source: AGHT+IGe9LvVUiCmyWOQ7PogY58zzbDaCGsnTCxvqtCK5LoRn4egVnHPNL77qWcYwy087wXspgjGLQ==
X-Received: by 2002:a17:90b:380c:b0:2ea:5dcf:6f74 with SMTP id 98e67ed59e1d1-2ee08e9d449mr25720043a91.3.1733089620558;
        Sun, 01 Dec 2024 13:47:00 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ee6ebc4a73sm2604366a91.0.2024.12.01.13.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Dec 2024 13:46:59 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Haiyue Wang <haiyuewa@163.com>
In-Reply-To: <20241201171247.23703-1-haiyuewa@163.com>
References: <20241201171247.23703-1-haiyuewa@163.com>
Subject: Re: [PATCH liburing v1] configure: Increase the length of print
 result format
Message-Id: <173308961910.322244.17941654654063055307.b4-ty@kernel.dk>
Date: Sun, 01 Dec 2024 14:46:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Mon, 02 Dec 2024 01:12:44 +0800, Haiyue Wang wrote:
> The commit 906a45673123 ("Add io_uring_prep_cmd_discard") add an string
> 'io_uring discard command support' with length 32, it will print result
> with 'yes/no' value as:
>  'io_uring discard command supportno'
> 
> Change the string format length to 35, to beautify the printing:
>  'io_uring discard command support   no'
> 
> [...]

Applied, thanks!

[1/1] configure: Increase the length of print result format
      commit: 65da697660a47c0e97b2dc0bb06569ffe39e279b

Best regards,
-- 
Jens Axboe




