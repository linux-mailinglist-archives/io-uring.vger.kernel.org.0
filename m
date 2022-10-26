Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271A960EC0B
	for <lists+io-uring@lfdr.de>; Thu, 27 Oct 2022 01:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbiJZXNL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Oct 2022 19:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJZXNL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Oct 2022 19:13:11 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C84E8D216
        for <io-uring@vger.kernel.org>; Wed, 26 Oct 2022 16:13:03 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id t4so11265208wmj.5
        for <io-uring@vger.kernel.org>; Wed, 26 Oct 2022 16:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0IXoiwFPMNwAnuy/6+vF8rB/wXkSQX+0oSu5q2+znk8=;
        b=h9kb6wY7jRlkYqEA9HDHIpKStYoecUBhQqS42LImh80A8/qZcWWGJBfLnT1hQ8fNIH
         TrIKKqg4siieUqbW6qnf4kupjdPExbPq2nw03akSMhrcNMFlSkWPs7lvwdQHo4d/kISW
         B3xdIkjhfCiVMgglbx11EWkYKSpygf3rDIg86V/RlqqxxM34Uf7VOkjcIylDnZgyi8B2
         8oJRfhMwhpIFRQhQctnkMrzGMOaYZ2PAKlgwIlwAhCETcf64izwBocahZgWJZDcMalke
         X+WO+8a38urVn3syq8SfLK4ufv6FXHcce9WfGFdKgPDuHGOCFPWBD8oFU+g8CR1xbLD9
         T/pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0IXoiwFPMNwAnuy/6+vF8rB/wXkSQX+0oSu5q2+znk8=;
        b=3eV1Cvj+jD0GM/aEkvlEPwIVs6LVZp75Ab97zGv+ZXoXCEt99lWli5bDkFoWJeJbJI
         BH8KI4is9PnvYEam9rM40SLGgFXVZurUtt82pBPrxzNHGA0p4ZwYg+WAr6uGSVC5/++T
         n0FOrx91tT+FLQwKCER2NHRa/Dy/krO0o4j0oTeROJ4pcGCN5z6ZIomMgPJMMjhDelSz
         aNdD3ILcn6qUW7QLB2vTrZz2pFefSdgYFhvvLdUdgBJWL7vTLB7kuUsCreKIoa7SinSh
         YKBcUde0THwgxvy1D5DD91H6M8iKly/XyLqKDn26941uvWoX4WITIQ8rv/e3sac5oRws
         VPfg==
X-Gm-Message-State: ACrzQf1mQaNFvCb0DLCVmtyKO4yoU704dIVVbCCpCWGo6QDizuFuOTa4
        6LL2JaHEtjcc6huwEK9VeDC7RX/qaivWCQ==
X-Google-Smtp-Source: AMsMyM6Vj2580m/WcqK13SUb+o6gEr0yCuYfFs/i5ShcefHebGufI8jg352y3IdhQ75V1Hr079Z/Uw==
X-Received: by 2002:a7b:c404:0:b0:3b4:faca:cf50 with SMTP id k4-20020a7bc404000000b003b4facacf50mr3926518wmi.67.1666825981414;
        Wed, 26 Oct 2022 16:13:01 -0700 (PDT)
Received: from 127.0.0.1localhost (213-205-70-130.net.novis.pt. [213.205.70.130])
        by smtp.gmail.com with ESMTPSA id n11-20020adff08b000000b00228692033dcsm6386465wro.91.2022.10.26.16.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 16:13:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.1 1/1] selftests/net: don't tests batched TCP io_uring zc
Date:   Thu, 27 Oct 2022 00:11:53 +0100
Message-Id: <b547698d5938b1b1a898af1c260188d8546ded9a.1666700897.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It doesn't make sense batch submitting io_uring requests to a single TCP
socket without linking or some other kind of ordering. Moreover, it
causes spurious -EINTR fails due to interaction with task_work. Disable
it for now and keep queue depth=1.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 tools/testing/selftests/net/io_uring_zerocopy_tx.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/io_uring_zerocopy_tx.sh b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
index 32aa6e9dacc2..9ac4456d48fc 100755
--- a/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
+++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
@@ -29,7 +29,7 @@ if [[ "$#" -eq "0" ]]; then
 	for IP in "${IPs[@]}"; do
 		for mode in $(seq 1 3); do
 			$0 "$IP" udp -m "$mode" -t 1 -n 32
-			$0 "$IP" tcp -m "$mode" -t 1 -n 32
+			$0 "$IP" tcp -m "$mode" -t 1 -n 1
 		done
 	done
 
-- 
2.38.0

