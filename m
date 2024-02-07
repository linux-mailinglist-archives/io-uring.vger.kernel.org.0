Return-Path: <io-uring+bounces-574-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B1A584CFA2
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 18:19:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBAD01C20CEB
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 17:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1CEA823C1;
	Wed,  7 Feb 2024 17:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="X9DcdMXv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B3F823B4
	for <io-uring@vger.kernel.org>; Wed,  7 Feb 2024 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707326386; cv=none; b=T63Ap3lnzQArfA4Fqjb/3lmnJqNtFChFERTkYKYqP9Kgd6NXkrW1W1kNr+BxUGvXLA43ipiGmgD40khTOEO71D/jB7hmClyv86yy5CU6zmB8oqK8df1X7cFmUEPa1bPvA9rEa7CymU5BHTf8/QIiAMjj5EqqUHA0Scx9dlGh0ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707326386; c=relaxed/simple;
	bh=YyPIGFiGeJt0+X6o2mtzyHqnc9F/4QmjBboXC+ziYjQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=UvI2zaT9ZpjEb3mk7A1UdLeGPMU/iE7s7Df7sPCjHvfmC1MsL4zIY6S5R32cp82YqgSdR+rnb4UlhcuaX1n/IwjHb8Wk0C8Wk+yucLSl7BOD/DMvEfN3fp6xSGju0N1Lt73aL8mR6PMlEn2uf/lEXnQNDl7x0t8c2+KiZlKn4rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=X9DcdMXv; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-363ce7a4823so1208515ab.0
        for <io-uring@vger.kernel.org>; Wed, 07 Feb 2024 09:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707326383; x=1707931183; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=c+zI6MOr6Wu35KaV0HodaeQIsCtFxcrhmgA4qb7XPRw=;
        b=X9DcdMXvjJMTGVwIlRXx/JNsf56/NWOUldEDbgOI1aa4qsdA/PTKtgZ3zuwNVkeq4j
         dX+u6V0NCOqREva/ifaTu4IcTOWdJe+HVuytgIOGDQLQlYoGwkQzUqR7jgPwOBYi/DqF
         lqcrrb0YJ8JQBQEyVr7muESrm3dAPgh3Nsu0ENqB1FW0McLepHD5AiYKuKNIENJBZhs0
         EHHBqiPZ+5n/n746wzohT1t4wX+RKM8MYfqTYnyxHZ0RSZWvuZYDwOIfXl+UL5xDBgQI
         QatyA4Tr0PtJ8iGYAGLF6JvL9HqqGb19oC9aKdydSRSb1lPu/FDgGzM6x9H0iJFJogNg
         2OUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707326383; x=1707931183;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c+zI6MOr6Wu35KaV0HodaeQIsCtFxcrhmgA4qb7XPRw=;
        b=A5pvZGTLVSyZPFze7235lNdf/m6N/Hncy+6tcgTr/sbmMYU8opCAH2/G9l4MZjo6zK
         gFvBayJ5qYzcIT6a3c90HjVrYDGfKcPccn388QwKjDO888neIlUKOhdFTS20uO/gz0G9
         dF9xGdVNJsTmT2IkUPCpZXsU2ubS0reTGVqzzC7E7uPNm7q6h14BL/JXFXolYiz3vRcs
         6xudvD/kD6wH2hxPcUNIkDupvW+ywxiWTBszEKuHhtonrSIAQHWARrZ/Jc/OhfrKznMp
         HC7pyfejFkhK+/a4jGaKdZrs6lQSIsEmYziWqpD5NOry/oZNIUxBFTqvT59j0tFva3Kh
         N3CQ==
X-Gm-Message-State: AOJu0YyNI8aL7HXOguNaO7CsUZRsW+WBh/xzTyLXr/V8Prx/YsmZK1Vy
	q+M3qm3guKiKlcNz5pzFI94pihuF3y3Vq0ut7pkF4XG6RiDbVAX1VBf6KzRU+sVRbT/EymITfyn
	53Hw=
X-Google-Smtp-Source: AGHT+IHq6/l3sgj5ouN34IUXV7OPMCzUB1JVzgphhzJgeRXuqETHHfF+zJR3btqfCsEIiS3XfoCvAA==
X-Received: by 2002:a6b:ef07:0:b0:7bf:cc4d:ea53 with SMTP id k7-20020a6bef07000000b007bfcc4dea53mr7077116ioh.0.1707326383549;
        Wed, 07 Feb 2024 09:19:43 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g22-20020a6b7616000000b007bc4622d199sm421131iom.22.2024.02.07.09.19.42
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Feb 2024 09:19:42 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/6] Misc cleanups / optimizations
Date: Wed,  7 Feb 2024 10:17:34 -0700
Message-ID: <20240207171941.1091453-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Nothing major in here:

- Expand io_kiocb flags to 64-bits, so we can use two more bits for
  caching cancelation sequence and pollable state.
- Misc cleanups

Changes since v1:
- Drop nr_tw union with comp_list, that breaks iopoll with DEFER_TASKRUN
  usage.
- Rearrange io_kiocb again in patch 1, now just moving nr_tw up to fill
  the new hole, and shifting rsrc_node down to keep io_comp_list in the
  2nd cacheline.
- Add cleanup patch for io_req_complete_post()

-- 
Jens Axboe


