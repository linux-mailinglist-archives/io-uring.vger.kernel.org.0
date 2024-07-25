Return-Path: <io-uring+bounces-2585-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35A6E93C7E4
	for <lists+io-uring@lfdr.de>; Thu, 25 Jul 2024 19:58:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B243FB22347
	for <lists+io-uring@lfdr.de>; Thu, 25 Jul 2024 17:58:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 600A519DF70;
	Thu, 25 Jul 2024 17:58:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C795C19D8AB
	for <io-uring@vger.kernel.org>; Thu, 25 Jul 2024 17:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721930285; cv=none; b=bef1hysxTyjeiORwcxnKp/1syHl6DAl450kkedJwF3BV0cId7ELpIIgCIQyN+JVsXZLWE9JmY/gPLDS3TJfcC88YtOLrIt+c+Q0bfy6MP0xmnFJSKIl/80G8lNtzNL7JjwFKL+7uUIHxvuQNKvk/QXiL3IjbUvnh+FXkLJZ3qcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721930285; c=relaxed/simple;
	bh=6NEaq4l2buYl7x6xZlTTaT6BpFMzae8M0kCG8Y65iXY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=K6gIylLMkP8aQsp0mLJ0kVtqHLewQ1vs8KY3qCwJ9ay0B7Hmywnd5DAPQ5OBV3dOeujr+zSwn7T4Gw8ByfbYXHpCt1Vy6fYfARxBGkNhva7ZpM91xAk2ubyvYr/ExXZVCYCn8d7wVi9yRpD3vdF3Oc5I9z0uzlITl3KrFYA/61s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-802d5953345so55709139f.3
        for <io-uring@vger.kernel.org>; Thu, 25 Jul 2024 10:58:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721930283; x=1722535083;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5RXFrLVSSr1jSw7Uaz4eXW9EXsQq3IlHIBCkGDlAtAM=;
        b=F6MkAys11clteSvUfq2G+61H2peDvaZ3oo6UhYLrXOLhNcSk1aEYmlFNOtDN3OMre0
         vboe9Ni2tf0sQmZdPC9OkuGId/QAkVhrasQSeSxhMHTJEeCwbzNxuk6bwGHxHkyCii3Z
         vSE1wCL3YHRLGekgrkKC3c+vzyzu3S/Kky7cceaqCda2EZOt5eHGJ+GS8JhZ/KB+/r2I
         LU2fvABSWhybHCCBfMj9mxOe2etgEdcJDewYMoWDiD33hUEz+SXUzyX5aQwcU7gM/e1e
         xDDqDXMWEuN3Bktp4vEdkNkZF7ahNUuiSVXoeiSgEGSwldjqTXxCXsweGiQ72XJQthJu
         pL4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXZ8FVVSsT0cDlxegQ1gLE7vp+/wEFSBw66gAdnhPkTWy3u26T+FruVQH3yUVW7RkZy3rHs/PbdvUyKyIAjz4r/jhcuUjeujFk=
X-Gm-Message-State: AOJu0YyPf+NQJ75MrhK+5Ic3L3Sae7ge2nNyAEhGOzUe3vvb0idAnq1S
	6Fnh6rT7aXOLOM1ZA19zkIGDVij44T0vcRBldLgPJIdVS/+FF0i6lHvsSinS62IA2MYcc8xyBqq
	Cye6KoU+17i+gsE+bzYr5ZQNafXNCVnb7gF0W7OaBUHB+MGJ2dGm1Hnc=
X-Google-Smtp-Source: AGHT+IGy60XSGeuDOQ4SWc/8GWLd8tzn06zYwWaag80jd6LgfVewTl0FI03n97VgjxChNqiwfFOpnH5wKGrpHcQCHUXZLfczoqG2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1389:b0:382:feb2:2117 with SMTP id
 e9e14a558f8ab-39a23ff3907mr1875685ab.6.1721930282924; Thu, 25 Jul 2024
 10:58:02 -0700 (PDT)
Date: Thu, 25 Jul 2024 10:58:02 -0700
In-Reply-To: <d39434bc-430f-4c84-b1ca-1025f55bedb8@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d78ec8061e1622b3@google.com>
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_req_cqe_overflow (3)
From: syzbot <syzbot+e6616d0dc8ded5dc56d6@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+e6616d0dc8ded5dc56d6@syzkaller.appspotmail.com
Tested-by: syzbot+e6616d0dc8ded5dc56d6@syzkaller.appspotmail.com

Tested on:

commit:         0db4618e io_uring/msg_ring: fix uninitialized use of t..
git tree:       git://git.kernel.dk/linux io_uring-6.11
console output: https://syzkaller.appspot.com/x/log.txt?x=124e0dad980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf984d38d0f9fb49
dashboard link: https://syzkaller.appspot.com/bug?extid=e6616d0dc8ded5dc56d6
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

