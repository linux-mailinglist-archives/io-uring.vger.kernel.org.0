Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6701BCC42
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2020 21:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgD1TUM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Apr 2020 15:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729148AbgD1TUI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Apr 2020 15:20:08 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4378AC03C1AC
        for <io-uring@vger.kernel.org>; Tue, 28 Apr 2020 12:20:07 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id d3so3665194pgj.6
        for <io-uring@vger.kernel.org>; Tue, 28 Apr 2020 12:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k/bw7J+967dvicOeJ3EHnrA9zXN0oH0n6WGWsrRzzu8=;
        b=fMJcxQer77zFWkqeKvHXZAI9Kleftb1bYNgYb0P71R0sYDLyGy7IgrO+092TgvuFiK
         4heneQSN7BfMdvvQQt011dVRQt+xqwXdJEcb2R9LIyzdSVvzNMvonrzcQoMMnq90U5lU
         BNw/SQiNVb4pB6HEhQObx8AQ+zcL6xHX+JdyLZd4F80e0x6GmShx420Mbn9HA0l7AGna
         5cO5XBDTfywnefi2HUkBEiyPsmnXHP1mi8JMIwOt0P/xuaozvIPYUkOPI5cF+cNrp59u
         U0qbMQFmLfBHVVb1FE0FXlIfuCBjSZKIKB/Fy44EubZpTbLLov/FCVVdz6W3IOZdbKX2
         gsqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k/bw7J+967dvicOeJ3EHnrA9zXN0oH0n6WGWsrRzzu8=;
        b=ksLj69ETYzdlePhnSwdCUvpOeKdkEZLNycGoBR2Ue3s8obDjHkxQPW810C+XAc25qU
         eHqZxhgrF+FA/k2sCEHTMOxTsjFtnFPynqLp7U47TUu9Z+rrPJCa/pxsBCZ43F3Ku9To
         S4kVi6HGZSILcyacfV9lxUKvxRSwRonjm/X9N2eD0ScLGa9z3aanKO1zcoGRnMkAGs8s
         Fjw16kKmdEZ1UDnkBYP/X93w4Iln31Ik/8EPB7asJGp1d+oILnTNoadOi6PtGV/OTr6v
         H4wRjpoqc85cwMiiN7HDGsn/nuI3SNvW0R0ef34lwWbOOpHewey2NIaDuvpSYC+L0nOY
         LJ1g==
X-Gm-Message-State: AGi0PuapPnaM+gl4pnHiCP49qdU1WBKji77fu/qEoNKgmA6FWje4JhGp
        OKcHHLqlthqr1vUP7Su3IlLHVsuLWL37CA==
X-Google-Smtp-Source: APiQypJVPJAHoVG7cwHQ3KkT1XdbEejjdKBUnuRQh0kICDM16SFP/Rixx+ePlGWSpUJYySOk4eaDaA==
X-Received: by 2002:a63:ce17:: with SMTP id y23mr28445987pgf.194.1588101606491;
        Tue, 28 Apr 2020 12:20:06 -0700 (PDT)
Received: from x1.thefacebook.com ([2620:10d:c090:400::5:7a1a])
        by smtp.gmail.com with ESMTPSA id u188sm15851946pfu.33.2020.04.28.12.20.05
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 12:20:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] io_uring tweaks for poll retry
Date:   Tue, 28 Apr 2020 13:20:01 -0600
Message-Id: <20200428192003.12106-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just a few minor tweaks here:

- Base decision on whether we can support async EAGAIN try on a file on
  whether it has ->read_iter or ->write_iter, depending on direction.

- Only force punt to async worker for read/write if we can't poll for
  the retry.

Should go into 5.7.

-- 
Jens Axboe


