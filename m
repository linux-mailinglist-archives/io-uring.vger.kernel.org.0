Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9DC2A50DC
	for <lists+io-uring@lfdr.de>; Tue,  3 Nov 2020 21:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbgKCU2g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Nov 2020 15:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgKCU2g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Nov 2020 15:28:36 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14FAC0613D1
        for <io-uring@vger.kernel.org>; Tue,  3 Nov 2020 12:28:34 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id t13so9390829ilp.2
        for <io-uring@vger.kernel.org>; Tue, 03 Nov 2020 12:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UU78oDMAydkrCJcfzEIZzgSFunlMbF3ksNo4/z2t1qs=;
        b=KLhwap9Oh/VFFHDD0RaEJDeEAp/zqRJRgvc/suO90Z9sXbT3GzD3SK2lg5Wsr8H2Pb
         fg4lsHFtcVxAhJVIYcvfW/D0FXYpyFNmTHB86RbJ/Y5dAwJj5nEktGH+ID+eqHTroUgQ
         F/40JHFOpPwvq3jXGRFeyBiQcgdwYTYi/Xa6lQH1b3MSgAm9Oak0ZP5LT6USoV0tEhRM
         UI2DU6hEp5qQdnR26EldCceNv1qVYCS3gON1b8xOWUQcxMJFnddh/Qrf1EaiBvnPpKl/
         ZMzrJoHO12jv1xZnEgDxbUADXwVsUzNGRhZaRF5TSPFozY7rTLT3lrb3nuAEvdSvRcc/
         OP0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UU78oDMAydkrCJcfzEIZzgSFunlMbF3ksNo4/z2t1qs=;
        b=iAPy/o36EEsrIFWhUUYJID+YIVwt7OjdaFG/B/kUxVd8fe4AZNr3FDTXCY2mcdpeC3
         xtMybF79LzGvbSlYKEk/QNzgskmWeQNPCaS4BlsV+I8XZoxLB1yIzu1A7FnLgRbTtF9F
         OcTqu9ToVNEpQv5O44KQXRGjoUn+g3yJwkVPCYpy/6fpRl5nGeYZwkEVWwSOJfxIEVM/
         lqgMSBW7+Jdo/8OIA1557d+qjyl4PamPEiEKvlzyllMT/JscBBASGi9DY7Yctjt6ejd9
         Jp8rLTztlPJsE01ZzsSD4rshCNX1wzI1LrX5338x+DiXWLSiley7ZUJs1ZHuoIBrtt1E
         o5uw==
X-Gm-Message-State: AOAM533ZSCV5rHHYQksB779C+ee7ajP5fkP4ycpTMyP74V2bCpuT2qLb
        DbPpQRlzetXnwdZWJRvggVWf54U9PIO0Vg==
X-Google-Smtp-Source: ABdhPJyGOdtm9uBqTT/qk3u5B/x49ybdxdG/aXipowG6k6l4eSEROw6mtQlq8Cf6fHymwY3hzM/Wlg==
X-Received: by 2002:a92:8707:: with SMTP id m7mr2600892ild.217.1604435313945;
        Tue, 03 Nov 2020 12:28:33 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d6sm13472902ilf.19.2020.11.03.12.28.32
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 12:28:33 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/4] io_uring patches queued up for 5.10
Date:   Tue,  3 Nov 2020 13:28:28 -0700
Message-Id: <20201103202832.923305-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

A few patches that are queued up for this release. All address issues
introduced in this cycle.

- Ensure SQPOLL cancelations are done in the same fashion as for "normal"
  rings.

- syzbot reported mm deference oops

- syzbot reported use-after-free for registered io_identity lookup
  and COW

-- 
Jens Axboe


