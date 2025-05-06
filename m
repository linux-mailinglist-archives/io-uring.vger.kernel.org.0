Return-Path: <io-uring+bounces-7864-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F8ECAAC70C
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 15:55:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E05087A3B2B
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 13:53:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66262280009;
	Tue,  6 May 2025 13:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="k3e67h+T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17DD27FD65
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 13:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746539692; cv=none; b=BACu7Y5cyldT0R2INAbfQkOvfmafoLhT7uibwLnnQVXQQEf4Z1j+ihi7wmQ0iIpzEv837G1p/KuKWH96VsQcOrzeBJ16RtMfDtn9L8NqbWsOyW19z2+zeXqJ6pQ7fpgr2N8pyO3+ymWCVuR9Yz8paH79x2x+LXZ2hqgrdecmvmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746539692; c=relaxed/simple;
	bh=wlsxvUiI6wMffoIB9iRRM9v+qj+6gkKmzZVFyg1thOQ=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bKeX+P7tfknUuHx45A1IwJyM+aQfIuoVkjlLA59dNQYgE4PlzofGt9DB7PvmLg8JA/3y1Ccfu475lfb5DOFOSjLAHZZG6/fCmgeXyaMj14KSQ9egp5Cx9u90pjPYwEVsbgM4txizaEvoCKxV4hQdN/EP5VKFIttDxTIO7peSmc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=k3e67h+T; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3d589ed2b47so19261575ab.2
        for <io-uring@vger.kernel.org>; Tue, 06 May 2025 06:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746539689; x=1747144489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cGvC12uTyShrTlpwnU5USqhKMd6usqdxR1TG5iGgDgc=;
        b=k3e67h+TeO3e9Ib3251iKUFWgmBQAImYmYImoZju+a/fEb6RhnInNZ3Gvdr2nanP3E
         3c5bJnchvqE4bqWQV9XOlKm3hI3fWsg1/wByfrhX/Q8lwWEa0h0u9nHOY/Nddg6l62dj
         srwlBj5K4RiX3KcojhgsEHeAH2MwtIqrPl8UMrJFk26RnFqToQYgjyzEoMaatMddMRN2
         dnSp9N1CKQVaqz70tAc2Ze0Kadq18Uh6U/bRgbnPFuDa8OZS0ZapX5vza1/vzZ07BmBJ
         rQDy6ehQDK9N6LF8Vu3L3iER7WUjkW7FkSyf/icc3ayOz0KzW3DUWYTS8K3AcTFc0XnD
         pYKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746539689; x=1747144489;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cGvC12uTyShrTlpwnU5USqhKMd6usqdxR1TG5iGgDgc=;
        b=P4ULJ1G5lUiOSuRRPZJvyajtdkodZoGQSAFH48tDQ8HAT/lsT1sYc2ZxjWtM4GqCAW
         KMEfmuwUu9FS+jyVwl0V8J/HUgRSU1zDlk8s2LM9CDEnEvbNbkFKP9r+mgEZVpi1AsLr
         N4z54Ua+CNvP6ibdHAroSRaz4gaoiO/wexvStZ5BtYfPHWh/gB2sduUTBgPbP+aC5GRJ
         1B0+R8md71J2NszvDH8sVwMI3g0LlnOJmbCIpoAAouz0V/nHOI5KUENAqnJj+LBkoab3
         vB4iUj7w7ydU3K3Os9kqpDZramkGtjX5TOnTHNrK7RB45sCmzORPygTMqvIH0LuSiXAi
         jmhQ==
X-Gm-Message-State: AOJu0Yy2YiS7xOsQHjpdXywsYlpPPx1BMC0wnMDOGQjSvD6ranE6OvK5
	PFOx1sHW61+KrAoq0Sk4zkS2HQ94sjz/KFoXNR9sKQUGFRWcjSWxpGXdI7n2vdRYxgGOH/iOSG9
	O
X-Gm-Gg: ASbGncsApMdF7jXb/F2b/5y+TTpUdCXtctpcGH2bQnXQtbpE2PEubJfGHXHfNODxWAI
	ErZvlOFOYQ6KJSpm1XN0LETHaR1ohYGUYDNJpHS75emH1W9Nkp5SftSNxl1wv0oWzk8ppoWHFm8
	TlsfmWRTzS9W2iS+A5BcLps3ZiiwhrIoy8tuL3vBAw3b6IvuGn/jguAeVm0kKiAG5qbCdAz9xQZ
	etZ3uNEOqCqVIyGGKqRtH4BaT6mNn/4q35BGmMAxO1u/oOEePF/OtTsCZojHAoPAExVYAG8j00n
	dL5AT5uoDN5jv/WO019UmZ6yN5dX4oo=
X-Google-Smtp-Source: AGHT+IExe52xnp5F1Js7fS3aYWJn6gAosQ4/0qGYQnsTdH7SXYNAun1Sp/0lZkqK9cJMaKqaG4JmCg==
X-Received: by 2002:a05:6e02:1d93:b0:3d3:db70:b585 with SMTP id e9e14a558f8ab-3da6ce9d408mr39236465ab.21.1746539689540;
        Tue, 06 May 2025 06:54:49 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88aa8dea4sm2220281173.110.2025.05.06.06.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 06:54:48 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1746526793.git.asml.silence@gmail.com>
References: <cover.1746526793.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/2] add example for using dmabuf backed zcrx
Message-Id: <174653968885.1468623.3071365328149638424.b4-ty@kernel.dk>
Date: Tue, 06 May 2025 07:54:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Tue, 06 May 2025 11:21:49 +0100, Pavel Begunkov wrote:
> Update the headers and add a option to create a dmabuf backed area
> in the zcrx example.
> 
> Pavel Begunkov (2):
>   Update io_uring.h with zcrx dmabuf interface
>   examples/zcrx: udmabuf backed areas
> 
> [...]

Applied, thanks!

[1/2] Update io_uring.h with zcrx dmabuf interface
      commit: 425f6d5c9b9371519990935e5412568fe736cc0f
[2/2] examples/zcrx: udmabuf backed areas
      commit: 93d3a7a70b4a6d6ade45a02915dda81c2cdf9810

Best regards,
-- 
Jens Axboe




