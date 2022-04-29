Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDCC514942
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 14:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359141AbiD2Mbe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 08:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359126AbiD2Mbd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 08:31:33 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EFEC90CA
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:09 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c23so7049892plo.0
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BQa3ZdO89DFq76SV5NM58JFod2kTfVivNu/FKHEB9Pw=;
        b=1YagvLfrdthzQcw+uMOE900hCFKjV9c7BD8t+s6FI6CCfrte0SPChQdEY8T03vWU1r
         ebaNk+8d654KNieGvoesbRVN6TjHcDhh/o7AlrphX05ZgB2VLhC70bXu8AAFMKch7sJ7
         d4D5KxxbFBv94JwjqVmGMuXOOcoQK5SYYPPVajJ9WfzQdRsoRcpWFeY40rSH0TkhUq2J
         pc+C3SWkjTK1vOGGDhcG9Gi8ChB4EwDtqZP3ca77yTUfGVFcV6HQFd+nwA32p1l7bNEt
         3bS6eeLpOZhEzsmVixSTgGA6rYpN3VpDY1vMLouDCXB9p8JQUCHSYdyBXnvm36OLnSgv
         Pjrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BQa3ZdO89DFq76SV5NM58JFod2kTfVivNu/FKHEB9Pw=;
        b=zj5z5AtmRyDXgCUdz2Mx+QyNzYfjyJpmAFupLXDpVrjseWKOlGIzuWxh0iYST8a7i3
         65cdZFLxfLMq+gJqOf3GbyhE4rSjm4akgE2PLfnEOJm4agXWzdtolEzsOjMIFnvOshd2
         SI+GA7bbK84npFdOjnZHfNhhgB8VnVaLZ+cqeyKrIXHPUO676VClOhbD+F7ZjwKQRnnF
         uWRYxndbstFDAMdd//PziC/TWYSQ/RA+ilZ0Zbv3XlFtAoBHWFB1+bUOoALGsqS3Cogb
         ecRVLpdMmOauEGlKIHW2rAnlms0Q7dO0a/k+3BWOKeZsNyAevEKqcufzqefGNVbvND31
         mDSw==
X-Gm-Message-State: AOAM530V2ufCkFfjNT7Sn27f+yKac6Eji3/hRBM1FaDAT/l8/ELZepfI
        60Gkfh2ZIb5HiSc2ATZwJL/WuuuJs2AJbwEF
X-Google-Smtp-Source: ABdhPJwaDKpl4x5kzQNOYFosrt8oIHKdC00N4CLhzqaAaa07aiVGIMuE8m3MDFizcSAPEXbudwbxjQ==
X-Received: by 2002:a17:90b:304:b0:1d9:752b:437f with SMTP id ay4-20020a17090b030400b001d9752b437fmr3620112pjb.242.1651235288177;
        Fri, 29 Apr 2022 05:28:08 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o26-20020a629a1a000000b0050d5d7a02b8sm2895837pfe.192.2022.04.29.05.28.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 05:28:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET RFC 0/10] Add support for ring mapped provided buffers
Date:   Fri, 29 Apr 2022 06:27:53 -0600
Message-Id: <20220429122803.41101-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This series builds to adding support for a different way of doing
provided buffers. The interesting bits here are patch 10, which also has
some performance numbers an an explanation of it.

Patches 1..4 are cleanups that should just applied separately, I
think the clean up the existing code quite nicely.

Patch 5 is a generic optimization for the buffer list lookups.

Patch 6 adds NOP support for provided buffers, just so that we can
benchmark the last change.

Patches 7..9 are prep for patch 10.

Patch 10 finally adds the feature.

-- 
Jens Axboe


