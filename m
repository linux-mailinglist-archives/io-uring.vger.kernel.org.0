Return-Path: <io-uring+bounces-949-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27C7187C4B2
	for <lists+io-uring@lfdr.de>; Thu, 14 Mar 2024 22:21:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58CC01C20C33
	for <lists+io-uring@lfdr.de>; Thu, 14 Mar 2024 21:21:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18739768E1;
	Thu, 14 Mar 2024 21:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QlwaLRSi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9974C7604E;
	Thu, 14 Mar 2024 21:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710451286; cv=none; b=idlYsbqraI0z3aeXUXmNXBrIH8Nu+L3YRfZPKsuQjfYIrWFm3BkQvMnFiI4iltFdbnc/0AJRbMpJZOYNULpfk7L2rcPiaAKCgWkwUTiUjWvVX1kE2+BznFizOWFR3Gb/+awbXgQYp5euj+281dcgNxC6olyCHUKBMAwJJfiQcmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710451286; c=relaxed/simple;
	bh=VTA1cvW0D1mdy4UByIqbD8SzUQ0WZ25CyYwNe72eg1g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gZxXlOOuJq/DPPunzGVYNN6Mzi5DsRpiLKxTto3e1y8K4u1JQNhiITiba/K0Z8SP6piTL+T5NB8A4l8/thYjB19jFzIOPKUzwgGWOvVYYqdeO/uGIZdT6pa/xdOlw7xO/8li3rZBPSde63dUS/TzOuDpSEld3orS+QhzmR7NFSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QlwaLRSi; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dd9066b7c3so10196505ad.2;
        Thu, 14 Mar 2024 14:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710451284; x=1711056084; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y7Kb/aDwmwhVYLJzC5a/6ReWiiRg5NdliMJgCY8nZjg=;
        b=QlwaLRSiuHpaa+OC+Y1GS+NrH7MpH47thXZIidBPJjveZPSrFXQSVTGu5XJexOXUdF
         cIKNHYR8kmTW7FzFSdE8/lUSUvQGsA9+bZ4Q6Sx7vDx9Q1HjB6QEhkaeSzgBAoBVgpOX
         eqAx5z7F/po/uN7oAVdx9MT+dFQpwB2PNjQdBFMuGG8Hy5suQQ9CJq7HzofVJRobkLbm
         PMKjxxUfuzYE35TWRasXENjwHqaCGnJ2UPCynPAC1/NF6pv7wCHeV6ydDBKzh2gCmb9W
         A2qvO7ssBZ085pTfUHd46xF4oCK0/Gtb/J6yXN8JvjK+RJO/KVX0qs47GYlKUYEzPBIU
         5E5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710451284; x=1711056084;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y7Kb/aDwmwhVYLJzC5a/6ReWiiRg5NdliMJgCY8nZjg=;
        b=gxK58UW0TXDnOhl73XwHQPVu5Dyi5voKjO7B3yXfXJVxMUSN6aRAaqojFJoZoXs+ru
         DxETi/nlQ7lSTPnaHi/03JA3k3rlk1MC4xmv0FJmuDhFYik4KNAGLQgV53J70TA8g3Hf
         yp+cSzuPY9LgWYt8N6JWUtAlJAMefXVehC0WcUwZSj9XcI5kKIJxoMmNCHRHv/F4xtea
         IMWM8mnIRFLVxhauJmUOEJW3E7id46SY+jiD6fK7FEDOcvfTmlMvT/c8LZ2dKIcn9rVU
         941pVOiRqypfSwGGE8uIguY7itrT/ka5pr5PRST7H2vAESOvs+UimJOAeZCxhf87h1pP
         mCxg==
X-Forwarded-Encrypted: i=1; AJvYcCW1PmhcmpDZMJrWwBxCRsRBK2MtmL88mjd7a5qpb7QPkas4/GF6Yi2TzkHyJ5qTPFWxbcDa5peMUTMKWW0eNVTFjXqPNLGQaai/GcR1skRa67ToKwkHE9vuDnnCvyiZG9yrEKIYAi8=
X-Gm-Message-State: AOJu0YzjE8gRtkkLweLmHx/Ynpi7O7e3a0K5mPnsoBot13Jm2cEDwLp+
	bS8XzRWzxXqEEGoXsUq8P3WGIeca4aVeoluEw/L9TodeoBo8ovrA9qmB/U2vr5gKTKHd
X-Google-Smtp-Source: AGHT+IHVpsr+VhgvJ/d1rChR3i1RB34LGrhPAtsog3qFmZcJY38fED3RGalkwSM9T0TVMYYLdmpoUw==
X-Received: by 2002:a17:902:904c:b0:1dd:abc6:7fc0 with SMTP id w12-20020a170902904c00b001ddabc67fc0mr2769898plz.65.1710451283879;
        Thu, 14 Mar 2024 14:21:23 -0700 (PDT)
Received: from localhost ([2408:8207:2572:7dc0:31a4:b729:4b7a:d450])
        by smtp.gmail.com with ESMTPSA id z17-20020a170903409100b001dcb4ae9563sm2215917plc.33.2024.03.14.14.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 14:21:23 -0700 (PDT)
From: Xin Wang <yw987194828@gmail.com>
X-Google-Original-From: Xin Wang <yw987194828@163.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xin Wang <yw987194828@163.com>
Subject: [PATCH v2 0/1] io_uring: extract the function that checks the legitimacy of sq/cq entries
Date: Fri, 15 Mar 2024 05:21:16 +0800
Message-Id: <20240314212117.108464-1-yw987194828@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


Xin Wang (1):
  It was really careless of me, earlier I wanted to keep the coding style
  as close as possible to the rest of the code, so I looked for similar
  code, e.g., line 4713 of kernel/trace/ring_buffer.c: if (ts && ! (*ts))
  and line 1178 of ipc/shm.c: audit_ipc_obj(&(shp->shm_perm)). Now I removed
  the brackets and it passes the checkpatch.pl script, thanks!

--
2.25.1

