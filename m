Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0D56156BB9
	for <lists+io-uring@lfdr.de>; Sun,  9 Feb 2020 18:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgBIRMd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 Feb 2020 12:12:33 -0500
Received: from mail-pl1-f175.google.com ([209.85.214.175]:45679 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727399AbgBIRMc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 Feb 2020 12:12:32 -0500
Received: by mail-pl1-f175.google.com with SMTP id b22so1818816pls.12
        for <io-uring@vger.kernel.org>; Sun, 09 Feb 2020 09:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jMHadhsndkDiwDLEGC4o/TYGjgW57KiFiDk6VWtkgPY=;
        b=NO3Q3IIhu3yFTYwYXYDEEQEQpl4YPqK5kmpG8YgjZTGR26Z2B7OMLDSncsjasaIrSX
         bV92mMEaoIVRRGlKnheADHnZG/3darAT9NKzkzLytd7T0AqJUo+q6pse/PABxsWctw+2
         uyKX+as6yitO4bpEr2DjsuvKt0amNCUSNk4DH0mIRy6QApqiotLacwOdU5NXDT7+UdoS
         Uc3TA5LZmjz89xMYcl/l+/SB0v4lPzizqTu9tgEODW9nGuWBD2cS8+8LYcoq9IbPARao
         Tzm1IzEju55DSuq8IMA7YM6Uv81N0oHV37nMAKcQaro91UrBOaeGy4IVP2nszIA1zqkh
         hrWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jMHadhsndkDiwDLEGC4o/TYGjgW57KiFiDk6VWtkgPY=;
        b=m1OUyEZ6R4TClNBDGiCGrKFUsQu218fdplU94wQyrBPe/7JJLlNZytm309YJiFvFbA
         QCjekfV130FWaBka99PNMUUQEKtkPcSrgStI+1uX5YhrCJbMBb2jpK3TAZY5EKpgTWDz
         cA4pzaTTjpTZpMl9lGo3FBjjCK96S1W8nU6Rhm3JKQXhsFnN67SYRVCIczZavJ8ATeOQ
         TdjEhrrJE8lmfhom9o5k9TXJ1u/cGDTy3dUdWKdXj7+/XNplV0ND6vbKObVGw2Zy4Ecv
         JYae0V5VM2cMyUXb61DvuuhJRmlGePz3WpL0w4FYneFrUFhFOKivbXjmBA1ldsXmQcGg
         1DSw==
X-Gm-Message-State: APjAAAVOCI1+XpOrjCZjF8sYvrIQyIbe3/m1JSxDD5oIKpMYyGCiTbgr
        E0BbVLGryfiudKO/cHFaySbXI29CFZ8=
X-Google-Smtp-Source: APXvYqzLemIjitQBKwquuWZSzykBg9N9TQLK6C3yb88h7SryEEnLMTLWVmb3sjtVYt9MbxwZsOWgJQ==
X-Received: by 2002:a17:90a:608:: with SMTP id j8mr16066934pjj.85.1581268350543;
        Sun, 09 Feb 2020 09:12:30 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z29sm9869695pgc.21.2020.02.09.09.12.29
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 09:12:30 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/3] io_uring: cancel pending work if task exits
Date:   Sun,  9 Feb 2020 10:12:20 -0700
Message-Id: <20200209171223.14422-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We've tried something like this before, but it covered too much and
would not work for a shared ring across processes. This one simply
keys the cancel off the internal pid, so we only cancel work for the
task that is exiting.

-- 
Jens Axboe


