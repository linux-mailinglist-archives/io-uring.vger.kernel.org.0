Return-Path: <io-uring+bounces-7526-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F2DCA92533
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 20:01:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 920CF8A45D3
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 18:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74B91256C62;
	Thu, 17 Apr 2025 17:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Pivu9uw7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2AA2566DF
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 17:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912730; cv=none; b=BtbTWYFUPLaTaQsTdbZ4vjzjxRv8yg2rFIsMjTQSb+9Jgqf+iQhSGzQwytdCKv8N3lDQD3CVknepzXhaTsezK12Dpihae/HkRRfiDeX8MQc+X/LMyof+HC/tZCEfcIC0C7GfEcfmgypF7UYMkhfGAGEed7/9LQDTirV+AgEpv9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912730; c=relaxed/simple;
	bh=60nJmnx3MpJvFHRrRqMRRBa8qayiooTzlCfcUmHdYLY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=RQCbGDzJ4+2RE3DqHr+/79WFsiKyGletODz98YhH6E8ryIg5FgP52WImkMjT2Lr+AjoGQW0uqi+qUvNur2bN4K0+nfKS0612H+iNRtOMoQrQpRuDzOngEKysiSnMCoGwhyUekAUWghFkm4PptepIAF6mq2592UXSQdY+jw4DcUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Pivu9uw7; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d439f01698so7107825ab.1
        for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 10:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744912727; x=1745517527; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c1Ouhv4iXNdiyCWT3HOHjBHRrXqfNmgu2cI3KFHudj8=;
        b=Pivu9uw7Ha2S3uLyr1mTLMAGVDRZMtSaGBbyks10xiojzdUMzEMMFkQrFx7W5ocpwM
         UcifvBs53Jub2NJtTjMwF7wv1ec1VmP15bBPdayxn6MelTC7t2mzGcr4Tp5903EDmSlA
         uMfkGcI9Y8E+nOPj5wXDnAiePitT9EUL6htkiKsf0GdJBeyx2rM5fDVCH7kxCn5F8YYT
         aWHoJdk0oJJZ2LGYeIjz4Ikt/W/3sFbrXZc4QtQqEMONS+Sg3oT7mrkyavwJlOOO5OW5
         qam25N2EkX6SNU6JShqtMNsyKABDOTKhTt0ptTtoGo85MbOCTRN6rFKUb7YHmyzcMkpk
         FnDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744912727; x=1745517527;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c1Ouhv4iXNdiyCWT3HOHjBHRrXqfNmgu2cI3KFHudj8=;
        b=MrFxPlVkRD9OGsJqL2fjfqaHXE8/FHvBfSUCIcMx0TfVKNgrrvORUkACNzquglvCp7
         EbN9+J5DwZRu7LoB3R5kl/OVFpEIyq5OwlokBGLywVxATFY1iccRwIrr8zg7yvXkX7pu
         i6XsHwX5b7OeXE5YRDGntH7rZDvzt1cFijW/F2Al2J7mhqKxe2Zeo3y7fjKXOO4B6wI4
         G0+qjZY7cRtTcpB7L+SX9zmApnOloZMoj5xLYeqFM3QMkKaC2Awcaxx5fOY9ih4ES5Yi
         i1TxrDTXi8GimdfNbujsYWprXwVgCoVzyPCn/ev0mCJ0h6zjm1aODowjqrOc7G+5bjUG
         5TWQ==
X-Gm-Message-State: AOJu0Yz61u1/8VIF+6/uP1naKgIQ+lPuSiDc8lQh+JRVuBh1t1oIf075
	Q8WYxZxAyTeB4fuIc/WAdAd1zr6Nn2BVd6Ui9EBeNV0I+emP6xOY4u4r+VSOc3s9pMavRF/lTfE
	u
X-Gm-Gg: ASbGncsuoj9ErjnAQLKGWSByWj+ViBoH45gJn2Ll3zNVq6AyrtsFoKinPXNNrYQUz2Z
	1FUxwdk2+Yl/IWSVEASIEfmWl4HZw5eCZ7J12hT8qO978D8vHffTF4qlZ7O6oZ6epsB4KIEcmBp
	esEw/Z407Yxy6veSzmBiJhq/rUfTSPfqWM9tMud5sBBKl1WhdpYL+y0QljC1WgKn5hEX2Y1lIg0
	X4jQ0NgvLrn5UreSN8L8mc0kNCXzL0SlqK3KC8KVdGKx4RRC0JV3a3mXJLa0+9mlfvHL6E15B2V
	LLUioIpisOYTYqBIkA5MrILzTGh7yMruk/poB6vFSZo=
X-Google-Smtp-Source: AGHT+IEUBlFC8+J/k502mwW6SqJWN/Wyqa9hfQ2e8//bXkVEzGoshv7m8swQsgT+0KShnh+lTblB7Q==
X-Received: by 2002:a05:6e02:c67:b0:3d2:ed3c:67a8 with SMTP id e9e14a558f8ab-3d821d3070emr8411085ab.4.1744912727013;
        Thu, 17 Apr 2025 10:58:47 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a3933d11sm56331173.82.2025.04.17.10.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 10:58:46 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Keith Busch <kbusch@meta.com>
Cc: Keith Busch <kbusch@kernel.org>
In-Reply-To: <20250416162802.3614051-1-kbusch@meta.com>
References: <20250416162802.3614051-1-kbusch@meta.com>
Subject: Re: [PATCH] liburing/io_passthrough: use metadata if format
 requires it
Message-Id: <174491272628.586352.6084809783557155719.b4-ty@kernel.dk>
Date: Thu, 17 Apr 2025 11:58:46 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Wed, 16 Apr 2025 09:28:02 -0700, Keith Busch wrote:
> 


Applied, thanks!

[1/1] liburing/io_passthrough: use metadata if format requires it
      commit: 60cf4969bd3eca3aba1fc24b6e0af7f92d155351

Best regards,
-- 
Jens Axboe




