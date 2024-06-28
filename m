Return-Path: <io-uring+bounces-2377-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D7A0191BBB7
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 11:41:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77D531F21122
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 09:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2912C153519;
	Fri, 28 Jun 2024 09:41:32 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B483715443B
	for <io-uring@vger.kernel.org>; Fri, 28 Jun 2024 09:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719567692; cv=none; b=jFVqxs++v7X/DavntEucMMiW2Vrrmy+ns16xuGjf6Yni+89SKZJ86VPwYSPzZJYTqKv/dvtQ/c60ScnpMtKM6KIt077EnFATcIfZKSq/8n+ZPOVRUVn5XhV1MEyf+NkAmE14tls13Blsl8ArMlEhkR9lRdwrowy6bcigPnODUgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719567692; c=relaxed/simple;
	bh=yO1zDuylT5rWn8ha52gqFPnR9QISsetCVs+zALr5qXc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=GUCaYcWXusHAK7Asq4TFciQyk7AjkwrNudSscVnF1bqyFmwPkkPhD0QYpyitB7c2+KXgnurwK3kh/uWtBaLLcC04wN7O+QiRF6kc0eDAhuhSSbU4wI1UimJM/lezkj4Mtks82dnNJzoHm5itDhW9pRI2bCYGwgArxnXw4cOt1Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-37715eaa486so5525385ab.0
        for <io-uring@vger.kernel.org>; Fri, 28 Jun 2024 02:41:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719567690; x=1720172490;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2NGXqmOLebbDJIT9oTfJXpzUo10RZPHybUkmo2OlM2I=;
        b=CwbEMQGbZaN1GB1VexX1sySSNMPmDmI4AriJxFZhzTIfYjUUCsbBi1pO2BCNiugMx7
         qY5z+jB3hhUJk2j76Nc3CNyc3yLKjtiwxcurItSIGNOz4vzRQo5cZfqdYHvLPOtHqLhB
         FvDhUA7vKXWbPSdtatlXmLkcxiYWQIgzyzEq9wuCWsvdesnnoY5Wkx33H4coRU9u98sP
         Vnys0I3lmD2VvzRwiXhC7e15sEVCHs5NR+YkB8hTglLeZHOEX+SGe5/vLUyi9YLcXB32
         Pv6NdkDhS+qQkyAxSHH2iQZPFkG68vwwwx5pRrcdVYi05lIu6GgNmkeGrBoTryi41YEI
         yMgQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYb6eo9R0Y+lJOlevYidhmUDSxBtb0UhOPpl9HxmFjqiHqYAUbaJ5NiCGa3i4rCcLXrf6Nw/9sWVrspa6gqH4ZalGTxSAGgiw=
X-Gm-Message-State: AOJu0YzQFES9esErlGGt5LaZg+sCQOwHoy0wlo+ex6+JuKXQvuzJ3NAL
	vFzCKatNmYf8k/URv27EmL3szMQhq5tp0fQw7KUf9NC3qkE5g4iBrYQjHNNefHfyjEQjV2BswDe
	n6Caqu5eR2SZk+EPhOAzYrDvckKJwVCaKD0bNv4NS+V90fRW/l5Kr1ZI=
X-Google-Smtp-Source: AGHT+IHdeejDSZhAn30k4xm25I7eJXA/fLrw4Z805HzDM+y1JExIYlj7qBs9T/+DDEHvSmAW9/2RfvbhaoB5y9fsWKiWHQ6WzfeT
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c54b:0:b0:375:a50d:7f2d with SMTP id
 e9e14a558f8ab-3763f5c9fc5mr15563345ab.1.1719567689830; Fri, 28 Jun 2024
 02:41:29 -0700 (PDT)
Date: Fri, 28 Jun 2024 02:41:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000051e313061bf00dcb@google.com>
Subject: [syzbot] Monthly io-uring report (Jun 2024)
From: syzbot <syzbot+list9762eac493f50a993bbb@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello io-uring maintainers/developers,

This is a 31-day syzbot report for the io-uring subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/io-uring

During the period, 3 new issues were detected and 1 were fixed.
In total, 6 issues are still open and 94 have been fixed so far.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 3582    Yes   general protection fault in try_to_wake_up (2)
                  https://syzkaller.appspot.com/bug?extid=b4a81dc8727e513f364d
<2> 16      Yes   KMSAN: uninit-value in io_req_cqe_overflow (3)
                  https://syzkaller.appspot.com/bug?extid=e6616d0dc8ded5dc56d6
<3> 2       No    KCSAN: data-race in io_worker_handle_work / io_wq_worker_cancel (3)
                  https://syzkaller.appspot.com/bug?extid=90b0e38244e035ec327c

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

