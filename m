Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22B346EC66
	for <lists+io-uring@lfdr.de>; Thu,  9 Dec 2021 17:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240716AbhLIQDe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Dec 2021 11:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239832AbhLIQDd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Dec 2021 11:03:33 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D77C061746
        for <io-uring@vger.kernel.org>; Thu,  9 Dec 2021 07:59:59 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id u80so5789331pfc.9
        for <io-uring@vger.kernel.org>; Thu, 09 Dec 2021 07:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=luGXX7YfnGRbhc6haQmxFvEOin62WmRD4qzh0DjhbG4=;
        b=AthNWAHbP2LeW9YsEl/tqu4wkGDs3Fm4MIP25S6A2+oqponof792h/fHaw6Yfp2XlR
         eCx46ujEb29MIPu1GI8b0l3K7nNg1UuC7ZsnZRGcAbJefcom/KnMpuVy3KzSyaE4rTmi
         0OAkP4E88R6l0TiVQpthCMF+UoJzNkC87WnlSQRG9T+UM774NB+7u30PM4jrvtB4GYdp
         OvTH36XZv3shTCs8Sa1y6FdMsuOJNM/rpxdW5zt1t9gknddQBNCElGR8ZiTA9H1+2rZ7
         jt7y5sw3dvWNDpNo/oaMnJ/ZYA7W61H/aS6xXVGhJXcVhXeiC1A+4BvQ734yyHiZ+gXt
         kqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=luGXX7YfnGRbhc6haQmxFvEOin62WmRD4qzh0DjhbG4=;
        b=mzMVLhUBSYPlSSg5or/4XEptbHAX9kHadkNPm7soplLLVQHF2bZDP9VgO8eB5jA1pi
         C/yoxRAdg3BRW5wnAd4DOqYLClFpJY8DZtYByuO8UgIP0RDS9XB/aMLY+l3qoD6jSIUL
         pyp/0+sDx8GEF0C42qDnVs+8f5w4DMaWgPVz7ZU9xuS/W61VyGTVmH1+YW19Gtp/3AlT
         siK1WNozqWuiHFpJNuyGGxcvb4V35Dx6/RVKtJ+Kr+l7Ri4JLiJtyuu71v+PKMce/6L2
         W9N+135E0Ok3m4wz7W8clqkBt14mY5SCsl0pW06qddx1z3X5bphEkAbO3sXFn0iv5ND/
         VNJQ==
X-Gm-Message-State: AOAM5337efbNgaUTCh25oh1CjNmKVdpsl5Vlc0KfWUMvKpAUT2NkaQ+C
        v4PNfSGLjSnIetz/CyUS04w8SZU7WZo+DA==
X-Google-Smtp-Source: ABdhPJwY4eRzgm93HZp3wfHpbYAh0PHZ4GZrZm7SdOmZDaAZ58NLuXr2mtqvLAlURgZ/geY+VARZ/g==
X-Received: by 2002:a63:6a03:: with SMTP id f3mr35141884pgc.618.1639065598480;
        Thu, 09 Dec 2021 07:59:58 -0800 (PST)
Received: from localhost.localdomain ([66.185.175.30])
        by smtp.gmail.com with ESMTPSA id q17sm146875pfu.117.2021.12.09.07.59.57
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 07:59:58 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Cancelation fixes
Date:   Thu,  9 Dec 2021 08:59:54 -0700
Message-Id: <20211209155956.383317-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

#1 fixes a missing wakeup on decrement of a value that is used with
the tctx->wait and in_idle tracking, and #2 ensures that we properly
process task_work off the cancelation path.

-- 
Jens Axboe


