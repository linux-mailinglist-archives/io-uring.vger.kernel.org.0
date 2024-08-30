Return-Path: <io-uring+bounces-2980-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 057089662C6
	for <lists+io-uring@lfdr.de>; Fri, 30 Aug 2024 15:17:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 387F01C23582
	for <lists+io-uring@lfdr.de>; Fri, 30 Aug 2024 13:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B9A1A2860;
	Fri, 30 Aug 2024 13:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZUchn5yA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B27196C6C
	for <io-uring@vger.kernel.org>; Fri, 30 Aug 2024 13:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725023863; cv=none; b=INMk0PcFV3U3DmD4bCrtuGyU2s7tU00z7WZxMt4RvQmq+jDYf3iCpU6jopnzb8dNWqZ+hU8k8iVbOtvw4U1dF+XCrOBI8gl/LjZvk/1CZtLG8kfGfepvd+d/coL96KreeizIA1Mes0FbRLfOLZanNOOXsopWI5e9BZIfa/LkTDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725023863; c=relaxed/simple;
	bh=8hHHTVXeCMVObgFOFwYkipfKe3IqxVNiV++1Xj3m8r4=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=RKNh/H0avQLB7bUWsOWYH1RV+0gqs8D9xRAo+yQd9luxqo6BNx+9EvJrkWrMBUuuqUm0wFgfIHq92D8mOReK/9r+6grw80Flc5+yt8SMj8GYy8fCP4kma6ceNMk+fa/8TfZLYMPBxSdbyVgwVx5TS9YE4PkvRlupA3XRsqet+lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZUchn5yA; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-82a151ac96eso67395139f.2
        for <io-uring@vger.kernel.org>; Fri, 30 Aug 2024 06:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725023860; x=1725628660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UjzCzYlHUx6rjakM5ZCYLKVDsy65I6md9qVmUmHh1x8=;
        b=ZUchn5yAGbolUpU7K3/tUkVCmUU2URlfO1ypPrnGNQivbFNdLOELK+UeD61pISzpGO
         QDELnMvcxXP63PMR0GklnFtoPmieI0j772CVAWWK2Wem66Ko+M7PCk3k023tJk1rlTQy
         GGR26zgTErh6b8+cAVeOslb999Hyy3TUVqFr3xBUyamqBqeCcUOg5x76Tp7gq1XEvvbB
         UNGFT9qGGJcCR+lGadet4Rl/Mp5PkTSkB1S6z/6uMvFyZCHcbU44piSjWxLSAvB3N+h9
         sALDLUvEbGnXP2I/eSzywfot0szUL2G9qde2nYpjA8HxETRpyp2TAcKxmi51GlA04ZGG
         41KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725023860; x=1725628660;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UjzCzYlHUx6rjakM5ZCYLKVDsy65I6md9qVmUmHh1x8=;
        b=F5TGF783boidkyqNbTHD9SerAcYdXHq0W7ymjcFxr6HywtX3JMlbVTUcea0A41v25Q
         WoQnzTcQAYiBcDilXsIRrkEQ7N7vCzZcNY1XC14Pr+2/fyF4o+uKGxnK+XndYw1bZrNo
         MLhMwmQ2n6yS71XTUwC0l/G++6/SuJgIPzz1QV7wUrT7SDnsPqzb++LryScuRaMJ0mIi
         xbvmWboYMgt/RVipBDkC40q9kp8r2gN+vJIWlmhe+wdrPVE3f2UUY3z/OpM17vltLlxF
         1S+Hh3Wk1Jo2tZvzCjNttmOH+hUaPbWBhpVKVWQwbSot5enyxuNdjvAKEGBODwPw6B5T
         +4lA==
X-Gm-Message-State: AOJu0YzZCjtWWFJ9EkiemtttZN+OnIpCCIYUK2f0/q7sSv8u466TfOW+
	GFDCjV+oue1+w7JJybtBzP1NnARqX1YBPBXKbZi+MgbGKlmS0J8n2XA9xSHbCqY=
X-Google-Smtp-Source: AGHT+IHrTjkK31lAKxz5jvQfOYoDpKNbohHpaoBMqzpYgoloT4Ll/yVKytKzbxxwY/6aU6KYq8rHOQ==
X-Received: by 2002:a05:6602:640d:b0:82a:2fe8:59af with SMTP id ca18e2360f4ac-82a2fe85b24mr99834039f.9.1725023860047;
        Fri, 30 Aug 2024 06:17:40 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-82a1a4c6034sm86534039f.49.2024.08.30.06.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 06:17:39 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
In-Reply-To: <20240830025514.1824578-1-ming.lei@redhat.com>
References: <20240830025514.1824578-1-ming.lei@redhat.com>
Subject: Re: [PATCH] test/uring_cmd_ublk: cover uring_cmd uses in ublk case
Message-Id: <172502385940.537652.14077009563309282871.b4-ty@kernel.dk>
Date: Fri, 30 Aug 2024 07:17:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Fri, 30 Aug 2024 10:55:14 +0800, Ming Lei wrote:
> Add one ublk test case for covering some uring_cmd features, such
> as cancellable uring_cmd.
> 
> In future, new future can be covered easily by the built ublk test
> case.
> 
> 
> [...]

Applied, thanks!

[1/1] test/uring_cmd_ublk: cover uring_cmd uses in ublk case
      commit: 87d59eba66b43ab02726cee9788ff31d4517ea3c

Best regards,
-- 
Jens Axboe




