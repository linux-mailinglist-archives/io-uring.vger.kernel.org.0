Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5C15B5080
	for <lists+io-uring@lfdr.de>; Sun, 11 Sep 2022 20:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiIKSSH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 11 Sep 2022 14:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiIKSSH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 11 Sep 2022 14:18:07 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CC924975
        for <io-uring@vger.kernel.org>; Sun, 11 Sep 2022 11:18:05 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e20so11966850wri.13
        for <io-uring@vger.kernel.org>; Sun, 11 Sep 2022 11:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date;
        bh=m/47gjAQAuKzHje9jbXM0BRPLUwoKwu9cwKfHQJvJR4=;
        b=nNzNx6iEVPIFUj+0vZC9w84pjzyshZ4ach9DPFmIIwcmr+6e0lfk+JqPVuHOM2Fk8M
         ptjlHrb4V3OYnzZTbLWGI1QOKAT52pvsuevIc3DR6dvtUDzox6cXxhBEGth1IzNf3J1z
         YTme2NUr/mUFn3VFzTCj8B2yx9ZtkITYBjCWNs/VNOpvVduJkXPxFXeruH+UAwLlrloH
         1sbiZXK4hDJS4HAZNp2CP7DYPmaI/NJ92oR6Qvvs9XcmtRgggEsP1iXl/C6Wn6s0D2Zh
         nRmtTd9AsqmVD+NP7YIbfZ7nH800H890PJHs3SaS3Me5Uf2JwAfSXy03nOBgZdKByy3D
         brIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=m/47gjAQAuKzHje9jbXM0BRPLUwoKwu9cwKfHQJvJR4=;
        b=kbNv7CTCfc5ClqVk4Kur2n1haMglc+V63nrfOWccAzAFqlRrAIN+GKVZT1WQgV6xQc
         RtK4oJ/EWbg+bewmxZXWBh9omqT6mAkY2wqZl9pJryvgbFVBDyX/gO0k5yi8ciJrfb7a
         0RakhyNnRn5vQU6CWYj6qmlW98zt9oa+tOT3vfdPnou5pOdBa+sMgx7FAUeJ3yHuGAST
         cb2VboKCIR267QuKxxEdzdG02hkBJ7dhPngtYEX3kjhNGGHlKg1nyp067Rn0eu+QesUx
         XY3GpcwH5MDYgaKRPSYVo3Vkl21kmjlagmsQoTLx5S81ORBkFJ0tY3ppxjEufRY+kk06
         cDeQ==
X-Gm-Message-State: ACgBeo3QzmhdXQiwOeFUDtk9egRlBCAQ5XKZg8rSUsBW68XSBBv3E3k8
        ACLiwhHxiyBcjV6woBrYZlKljdADxMloI/Joy9I=
X-Google-Smtp-Source: AA6agR5/UJorRktoSPUsC87HxF/o/xqMO96vQpu3yTkAkgd+yV/hCeB5r30I52KdwSRpoNWpaG9zcg==
X-Received: by 2002:a5d:528a:0:b0:225:4a8e:221e with SMTP id c10-20020a5d528a000000b002254a8e221emr12503569wrv.145.1662920283439;
        Sun, 11 Sep 2022 11:18:03 -0700 (PDT)
Received: from m1max.access.network ([185.122.133.20])
        by smtp.gmail.com with ESMTPSA id v2-20020adfe282000000b00228dff8d975sm5160056wri.109.2022.09.11.11.18.02
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 11:18:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCH 0/2 for-next] A few fdinfo tweaks
Date:   Sun, 11 Sep 2022 12:17:59 -0600
Message-Id: <20220911181801.22659-1-axboe@kernel.dk>
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

A tiny cleanup, and then a patch that fixes SQE dumping for SQE128 and
also adds a few more sqe fields in general.

-- 
Jens Axboe


