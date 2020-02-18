Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9DB162F80
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 20:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgBRTNU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 14:13:20 -0500
Received: from mail-wm1-f42.google.com ([209.85.128.42]:32961 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgBRTNU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 14:13:20 -0500
Received: by mail-wm1-f42.google.com with SMTP id m10so2875759wmc.0
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2020 11:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p6slRRnN882gLitV62ag0jv8dhxpZDMOQYtaKTczW1w=;
        b=peG5FYRX2bClMJGeC93ao3a4+OzUsWZa/NN08UDyItC8TkIrvQ5vZR7NklHph11pnk
         s834UjfbvRVc4UxlVCj9TktNruqHR6Z7kszjeKFO2/dghMoKNt5AmfDskcZS5nuDACPo
         p5qFqLaktqf/uOz0bfv3Q68XEfrj+22lP8w7rQL8gfd0dKyvzKqAkTut7U081vpVlPdz
         YZ9f3T5dSBcfMDl8iMsKVrL03ElhPy6jqg7WVVoK8TKrXww17EYRsVRWB4W/ZSM+zd/W
         /UULprMhpUdUHRreIOMsbFo1l2PFqOuTuNazKQbvhU/DxWxJoa0xb+vyfXFMQSV6gEUO
         7bVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p6slRRnN882gLitV62ag0jv8dhxpZDMOQYtaKTczW1w=;
        b=Zzz2yn5eHzvqNE0JDNdgwIfB3fWPg6i9lw0vqW4B2VOEM5whyYJLbX1RTEllxRJKGE
         RWhCikwcXNOJAN1gqY8ZKUVY/s/qWI8FsrL2GxP/bcGTZguAOKvWJWoJq0lfNJs3cFCL
         GMmHTDancOBz1DB9FY7eZ50E9GNDxFr9ZN2Dbul90QT+JtAEV2b4Pu6Ylt/zKRINGEXc
         tl0AT4JZq0N9P2ifHwsS59pOPyFW3JPaukQ3cGwEdmJe1AK9ARdv3S/0GW7FEjSk48iA
         FQ57XtcoSBsK8H1RJlhTUQNyQOGEggoumqn8ZLZAiQvdRQECzlEytou2rt3H+x3DhH9v
         R7vA==
X-Gm-Message-State: APjAAAXXruKPH5b11WX6lm9jnXqndEOI7sfraVHb09vTWRvsTJwORbAK
        2jmzHdr7zO+vW1naaJAc1hQ=
X-Google-Smtp-Source: APXvYqxvIdwzusZy11tYjHHq0e0PxyZnNIZjqEa4MBUm31llZ7aaEMoVGN46kuoaxX3rNA2PVfb22w==
X-Received: by 2002:a7b:c119:: with SMTP id w25mr4771893wmi.116.1582053198714;
        Tue, 18 Feb 2020 11:13:18 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.56])
        by smtp.gmail.com with ESMTPSA id h10sm4623561wml.18.2020.02.18.11.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 11:13:18 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Stefan Metzmacher <metze@samba.org>
Subject: [PATCH liburing v3 0/2] splice helpers + tests
Date:   Tue, 18 Feb 2020 22:12:28 +0300
Message-Id: <cover.1582052625.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add splice prep helpers and some basic tests.

v2: minor: fix comment, add inline, remove newline

v3: type changes (Stefan Metzmacher)
    update io_uring.h

Pavel Begunkov (2):
  splice: add splice(2) helpers
  test/splice: add basic splice tests

 src/include/liburing.h          |  12 +++
 src/include/liburing/io_uring.h |  14 +++-
 test/Makefile                   |   4 +-
 test/splice.c                   | 138 ++++++++++++++++++++++++++++++++
 4 files changed, 165 insertions(+), 3 deletions(-)
 create mode 100644 test/splice.c

-- 
2.24.0

