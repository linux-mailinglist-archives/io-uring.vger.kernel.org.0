Return-Path: <io-uring+bounces-8703-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4D5CB07B72
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 18:45:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A73950317F
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 16:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B97433AC;
	Wed, 16 Jul 2025 16:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="klPaW0Vb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C483E2F5499
	for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 16:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752684275; cv=none; b=tUbGFivpz8HJHcTigkwoH/SVfUFAidfFV4LULZ/+yIT/aAGcE9t2E6g5vnGmG6rz3J6RzB94B8VjXRXIEM5h4tWGB/lr5Waou8HgG77hKXt9MRecfhQl5owE+JDnmBSqcrW96pJQE60UmEizSKakztOsg1EVf4ThCPpR8EiRw+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752684275; c=relaxed/simple;
	bh=Z7r5wXsfupg8gKPuJ2++oCCfd2TS0tCff918r6GdsCU=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=eYDZpsWNeyVrxKqpj3ieH6iwsgsdeQWXCBPUCXamvySFTTO8AUjr7cDfwHRrwGzgVC7zdoyN8VmB8SQUqJfi9ibWxLW1Smlxp6AXF3Z8AEyV0TLVh01IoH+Hi42dEJzgUe9nk7CDkh3jW7+bvqua/LOcV8+67U+x2O9FQaQJvGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=klPaW0Vb; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3df2ddd39c6so100105ab.0
        for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 09:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752684270; x=1753289070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S/5jEhvuLkHModfriP2Pk36qWhdumttm5nGye7I6MI8=;
        b=klPaW0VbiTmVIF1dMCQNM0EYmkqAmxWFJ+5sIvdoNzDA//kuc6/Cj5Hyj/1ymNd+AU
         KB0ySOzdan11kBPfp2/jG05JiQwbZ6VvuWfqTFivTUqOGKkaSrNf5W7tY60hWC6Z6vsh
         P72JVuy/9Risp0lQ3rX8wPfydGqI1NsHMgXHZ4WbKcIl2RHkW7plBP/SF+wlP7SXTPK2
         u+FGgNvDEZ2yz8VryU6bzxln4q/+PcSVwx0x05cZxWrslQMCtuFSLbNVGDfbm+GvvhQY
         fDEZbRciKtItym/ifKGEHinQBUZxFTaTGf3rWvr6hdLuCHEIfsUihOuz2X7KKMGatgps
         aaCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752684270; x=1753289070;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S/5jEhvuLkHModfriP2Pk36qWhdumttm5nGye7I6MI8=;
        b=IdxVmQsxseg3MoKl7yYW6LtnAkJpji3q4ITskTD0kBKbm7kGKapbjuHiRLSCWm3ZCZ
         ISd+vKW/0D7LsPKqmAKpVHS7LYZK5q2/32L+EiF/Ao7q3u+bOd1GwfaEpj06AMtucj1O
         D3UY4gWUx3UolYdTlmeT4OO24B2uxLJtJp/GHkwhfb7o9e4kr+tHtpCQZW84PiRX+Zrt
         yxXtMRwN2cRYB5WwWyAMJExkgDkiHOnteaf7zvuuCcxMWC2OKvTMZ8SuhBVBaBHb6zeq
         m9frvhUBsM/wNSJrLNT2YkUqC6w83rZu5E31mGs0uPqfW0GbI952PV2S1VriPl8SgkEJ
         vIRw==
X-Gm-Message-State: AOJu0YwaHmGG00bQGUiiKQGucXRMiAI4E0B4oadKoOOtRaclCKLF3Uyq
	+5vzAFPNrPbI1wg2fFordYB57d6yVnedWat/bIfHk0O4fDbMmwEjTv1N9jC5YMHT+j713B3McvQ
	U6Dx0
X-Gm-Gg: ASbGncvAQ2qU0NUm500J4LN3i9kr1wrU3aXqmXvg2z9VrCC2tKak1fit7c0oGjsWzxU
	cU1pXUgTEDUTMczvomihEMFiRy8JpM+lNFrm7qM9+g9BDw4OPo9OkYRa0OGWTqmiDIdli90ChVS
	Gq+VSU/epgGSn19/CSGbOpLc7hYjrz06JnxZeECHZ0I0UW1Y6iPLGjQ58xJ5fMDd0p9rC+JwCe3
	smhotoXm06J+8zPV2iGub+puo4C1rG0gBmWo61Amp0ie5woKZjUAUiFJDPfnunDvJcbbBze4M0T
	2hbdNf7JjwW0/eR7qyr3qXfoRRs4njLz9UBJ0ShlNn3JiXVTae6VQYsAdG8RL2+27dmapp25aHo
	upGlpGLFih1XPkw==
X-Google-Smtp-Source: AGHT+IGkP52SOaZNA9ltDTKUxf3Iq2vsC5SRqYlIvltwbhEiBt26zXe/nJ0kr8y1F+PDC6OsHRQiCQ==
X-Received: by 2002:a05:6e02:1084:b0:3dc:7df8:c830 with SMTP id e9e14a558f8ab-3e282dbc4cdmr26721735ab.7.1752684270442;
        Wed, 16 Jul 2025 09:44:30 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-505569cc09dsm3052303173.96.2025.07.16.09.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 09:44:29 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3dc89036388d602ebd84c28e5042e457bdfc952b.1752682444.git.asml.silence@gmail.com>
References: <3dc89036388d602ebd84c28e5042e457bdfc952b.1752682444.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 1/1] io_uring/poll: fix POLLERR handling
Message-Id: <175268426947.340551.8353417084780430422.b4-ty@kernel.dk>
Date: Wed, 16 Jul 2025 10:44:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Wed, 16 Jul 2025 17:20:17 +0100, Pavel Begunkov wrote:
> 8c8492ca64e7 ("io_uring/net: don't retry connect operation on EPOLLERR")
> is a little dirty hack that
> 1) wrongfully assumes that POLLERR equals to a failed request, which
> breaks all POLLERR users, e.g. all error queue recv interfaces.
> 2) deviates the connection request behaviour from connect(2), and
> 3) racy and solved at a wrong level.
> 
> [...]

Applied, thanks!

[1/1] io_uring/poll: fix POLLERR handling
      commit: c7cafd5b81cc07fb402e3068d134c21e60ea688c

Best regards,
-- 
Jens Axboe




