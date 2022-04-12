Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E354FE980
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 22:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiDLUkC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 16:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiDLUje (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 16:39:34 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EB672E1C
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 13:35:21 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id s2so67678pfh.6
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 13:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sKPPb7cPnakqop3K+/8izaNbWGNMof5p7iEV5Vm4YJE=;
        b=kYmUWMNxcC+KqIVlArIbkmQRM98LpBPSJeSyGdeB1Ye4c8cbBdTLCd2Ey0UrainBLw
         AB3suwXVPPu+i1o0/mq31q6eK90+IN81w8eTVeDwf5r6CHTc1na0EM68MnaXJnlTjJ64
         NJsylaDD8aX1wT/BhdKImGx2SHOdjNZMk5KFVIo26NRAztXCRmMkhsmnuOqENx5GxNQl
         Ck824E280Ye2NvWUgVeFW7uY+cWdE4q3nTFgAcfsDIiHNfLDuT29Z7ecYaceL/rxuKCl
         OIP+OYveG3hJyLMUwOOk4rYsH/CAcl2pYWt6BmhD9S+aH2TA9IwKlPjk+djvcCnXLnEN
         WP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sKPPb7cPnakqop3K+/8izaNbWGNMof5p7iEV5Vm4YJE=;
        b=NLu7+M0YWAQzSNPQA9afcJNw5WlriqGef5/+Bnb/rBzF+rMkBKWRlTFL2YGy+gkKs6
         Q5GT2sAZWcmXoH4FgZvtWMSrWTKQHATqz0uMjdAGmxcrXZ7lvGKPNYc0FFsvGVezka5R
         7rvhV8V16mLIB9aIQnHItAoxI/mE0lZLtvptFNpOZm2wV7EuYiYVsO4x/aefl80ysC2m
         pE+7ujxfkyvqTo2+o4YIg47nVtgumLlPCbEK72yg+qR7VnwJPOFE7yZMt1FwgdLrfDCY
         TLle9DkBmAgw7iIN3idUUkiFxpMoTwzarmXJMXWEj6nHadKzFCHA3+rN8cKQoWfg2uPd
         mgdQ==
X-Gm-Message-State: AOAM531gHTUZGLX1FPZvhTncq9ZaHSIlSAUA9NbcOSnH+EToJkanK0xG
        7n1uTFLMFLQ/2euhIaFqVUsmshRTILL2TMu4
X-Google-Smtp-Source: ABdhPJwOBW9ho/sYBs6oClKSrSqGNqsvZpw/RwO8wihEqCCg8sjJSidsifugV6WfDh1w92B2RtIaoA==
X-Received: by 2002:a63:b0a:0:b0:39d:4d2d:a38c with SMTP id 10-20020a630b0a000000b0039d4d2da38cmr10379688pgl.394.1649794962965;
        Tue, 12 Apr 2022 13:22:42 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 2-20020a17090a0f0200b001cb6621403csm359541pjy.24.2022.04.12.13.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 13:22:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCHSET 0/2] Add io_uring socket(2) support
Date:   Tue, 12 Apr 2022 14:22:38 -0600
Message-Id: <20220412202240.234207-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

The main motivator here is to allow creating a socket as a direct
descriptor, similarly to how we do it for the open/accept support.

-- 
Jens Axboe


