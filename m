Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D5E4FC7FA
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 01:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiDKXLk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Apr 2022 19:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiDKXLj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Apr 2022 19:11:39 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D275412ACD
        for <io-uring@vger.kernel.org>; Mon, 11 Apr 2022 16:09:23 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id h23-20020a17090a051700b001c9c1dd3acbso845754pjh.3
        for <io-uring@vger.kernel.org>; Mon, 11 Apr 2022 16:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T8tFmPTBVG0n8T+JdFd6IdUX5Me/138mgKR39Hdlw70=;
        b=3v9/xdIDUCR29EnXQeK7fl+LeYAGLgp70M0JM7a6mUy8fjZeV6xw7Hr/d7/f7fEw3F
         AfkKJCMLD/h5glANpZh4RlWBKLm4Z0w9WzzaXde4DF0Bg+RDI5oPf/ik2WVRGidBZcQK
         8EOUU+fhM5Y86R7eBmgKnW+oEy9IGT6hGCnCZ7rkV7F1nEskNgG4LC+e+0u8KSoi+Oqt
         BllzD/65VbtLvBVVSaaUNlgv2mWazrGjW0KcNRqDc+jqo9hmEL56ahNTfcFVi7iIeX24
         RA+zY5ynioLubi7wIBLHIf1VRi9+iUsUqe1Nu/Rl48trAzaxAMf7OYWjqFXIWI/qdnFa
         dRsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T8tFmPTBVG0n8T+JdFd6IdUX5Me/138mgKR39Hdlw70=;
        b=qqAgsTK//oERRD9AWz0/fcbJkhdUbiXijls4peJWnYn7Y2Up8oCqrg9XLofcj5iEZY
         /3jlc6C+iLcRP4bSl9utrXq4Ipp23welIWVCx35wycvs7VJXLnXnn6Qnc5vtkHtw0jVz
         SEv4hIJaSR0Wgjh9ysD2sFO5Z1xJ6dC+9AfRssHZD26YU8LiJvy8H7rt2KP6Gwp8D+sJ
         1mURtQ8UIOwFbmOKprjrnHL3Pa4voh7xJHLRU822ZsSM8xP9bm0d0hxrY/KK3MPigPW9
         fVBfAEVl30L8Qu3Wo8R2o0PDUcklCmZ0/yAUlZRsZNMfN8YouMYtnPZ4p0+FPQIycsqu
         EBtw==
X-Gm-Message-State: AOAM5320Phx0sUOTJd1I7k5dVdT8deW5VMc2QSHFlMLJyhbAOosqcx28
        w4A85L6WanDeHP4MeALDWeXwCMcq+wkzkQ==
X-Google-Smtp-Source: ABdhPJy5QBQI77GZP7M8/oWAqfDh+oNIPq62pCHPO/46sZNjzeKqhEsi4I0ZfpXIUkCytr4P6KEqOg==
X-Received: by 2002:a17:902:edc5:b0:158:4065:a5ce with SMTP id q5-20020a170902edc500b001584065a5cemr12602311plk.55.1649718563024;
        Mon, 11 Apr 2022 16:09:23 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5-20020a631045000000b0039d942d18f0sm191614pgq.48.2022.04.11.16.09.22
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 16:09:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/4] Misc fixups for 5.18
Date:   Mon, 11 Apr 2022 17:09:11 -0600
Message-Id: <20220411230915.252477-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Nothing major in here:

1) Add a FEAT flag for reliable file assignments for links
2) Fix a perf regression with the current file position use
3) Fix a perf regression with the file assignment memory layout

-- 
Jens Axboe


