Return-Path: <io-uring+bounces-171-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 183F17FFBB6
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 20:46:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4E1E282672
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 19:46:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBEB852F98;
	Thu, 30 Nov 2023 19:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Yt/0j+7j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1D493
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 11:46:40 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-7b37846373eso16353639f.0
        for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 11:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701373599; x=1701978399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=gSjrdmYeud8jkRInCLywv3RIxMiq9wQoWdwhXzJowIk=;
        b=Yt/0j+7j9J3Ct5J73qYsN83D700GwAbiQCMIwVpVKIxITCFWp4bs5xTdfvyiUIEKgV
         Ywyqh+Wuwc/Zz+uY+4cOOz2ITnqLAnEMnSSRy0FkgZwCcJCu/l2lhW4pzx9B21jg0ZhA
         eWZnnYcjhDqBUnVozTTxP23xYCfiK6jDE506/DUiR7xNq4z1dkia5RatvQrQwZaYAnRE
         5oVtm2rI7TRMNvfYX5zrwosIIfHWVDIIYKiGqZplTZi+aSEkebQCQSIiKA+2pfsxx5SE
         i+fjhgXOAGUZMYWhjHKMHeXI6XnAzk6iQnijIWR1Nwz1ppFgRO9RC+0PJ3v5Z7Y92z4z
         uVrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701373599; x=1701978399;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gSjrdmYeud8jkRInCLywv3RIxMiq9wQoWdwhXzJowIk=;
        b=BE7MWHncOWGkLmaG64dceed6Wic4se3l5gKZHpzwFeDd0yb6Tt3b/quArHahVGbSk+
         oZlv6cNqugl/53DUTO4c1hv0zrPgzdIAzJxW2yHje16A3H/HcHlZ5/AuF9m6T8vWQO0O
         Ub8cY4r/EvaOwyvakiuCfEr4qVEDVJ1CDY69tgvF2tIxN5v5z2GSqeFrGlHwequbMEQq
         Kyb7Iiyd6KdYNcn62R/d0+T+ojG9ZUQXf2NxZi9lBXzFmXDTTVpSBDhv4OOSCKvKEzNk
         F+HHLDNQ7+JlEMQOMRB2MygGHDf5YrqpanttywpCuN8irfSGsLzOVxF98/DogyEIOggy
         B7Mg==
X-Gm-Message-State: AOJu0YyzBuW/s9J8T/vQ5J7Di78qhexvWYf161qVIEMZNL+8vplRa++j
	Zs5NwflXjpeygJMZcTj7qunjzYXU1Ghd+RmhsdJwLw==
X-Google-Smtp-Source: AGHT+IHWpGpRnMZQnu7kjv5zcSATh9JrclfrjboaYDKBQjp2KN1pVHZeMGcCqxyO2s0KdIkvkmLlng==
X-Received: by 2002:a5e:cb02:0:b0:7b0:acce:5535 with SMTP id p2-20020a5ecb02000000b007b0acce5535mr24376309iom.1.1701373599415;
        Thu, 30 Nov 2023 11:46:39 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a18-20020a029f92000000b004667167d8cdsm461179jam.116.2023.11.30.11.46.38
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 11:46:38 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/8] Various io_uring fixes
Date: Thu, 30 Nov 2023 12:45:46 -0700
Message-ID: <20231130194633.649319-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Random assortment of fixes, most of them marked for stable.

-- 
Jens Axboe



