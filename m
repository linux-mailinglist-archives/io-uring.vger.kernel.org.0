Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D984058FC
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 16:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbhIIO1p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Sep 2021 10:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239329AbhIIO1j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Sep 2021 10:27:39 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292C5C05BD2F
        for <io-uring@vger.kernel.org>; Thu,  9 Sep 2021 06:07:50 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id d6so2469114wrc.11
        for <io-uring@vger.kernel.org>; Thu, 09 Sep 2021 06:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fyju7fF+vKO2gKTxiqW07o8ZFTUFwhsAjlYNj8NJHts=;
        b=a7fkPVbew2+u/fUwU9DtPuPel7OtBxu11kmXzzAxdJ4kh1wIHlZiPk1dL/sM5+pW19
         AJdW+FcTC9/dIJ0cXrXQRv34X1tHwfxWkQ4TbbRLpAgRPp+OV4lcpX61M4l6OcDTaMdg
         DbFbj+3i+tPRJ2xKfIr6lEYZDYtrNTBImz5cFU2xqfv4BX6SFvauOz27Jwerf6YKbucf
         cARJ56KXqv9tHDB9I0IWAot38Yavdzd6G6FbE9sO+CnLNb/P+lGkhLlLD7WkqVf0uQBI
         xqDjz6F44gcphM2Q+653TqDApD9X44erWd0vmTqi5iR2PiH+CVTM7t8nM4v24BGS9hEm
         NXYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fyju7fF+vKO2gKTxiqW07o8ZFTUFwhsAjlYNj8NJHts=;
        b=nXS6Q+1nKHIde7sPL5FlOExpAYZCW9RgNgvvAVKecEIjDLqLTCMSvAcpMmsx3aDudu
         ZYHXtd5fAq+JwammQyvsn/uyMFrgkmXUobB6LLspm/agXxky9PZn9Oa9APCr+geVD51N
         3oQ9yel+6Y2i7dNDKVTJiEZ4D6+FR83FWP+HQe2jAGfUe7WpLWmfZaWBxV10XXZ7h69L
         NRvt5bj6pKXqaB1NgLuUsGn7xWkD0qqf41c1GqYJmwtAkF8lNy5r7DntQRfu0kw6eif3
         9m0LKLjQtxdKkvzE8VSP4dnlGOF7xvf92UDcvLLaxXjwMinSI/4Lr29N7dQ5c9quWIGl
         KXlA==
X-Gm-Message-State: AOAM532KS8D19/ginKKp5O3izjBRYS6eyHQWWtNJiv5SQw+qtIPtOuF+
        XWajtYdp7aQFTQI5mDvw4Q0=
X-Google-Smtp-Source: ABdhPJzVLX9feCtpqmDzKFs2+onAas86Lilw/HyG1wGVmdk6BjOo1X1Lou5ihOq9piTL+gk+hLclug==
X-Received: by 2002:adf:d193:: with SMTP id v19mr3517524wrc.377.1631192868700;
        Thu, 09 Sep 2021 06:07:48 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.167])
        by smtp.gmail.com with ESMTPSA id w20sm1762096wrg.1.2021.09.09.06.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 06:07:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 0/2] exec + timeout cancellation
Date:   Thu,  9 Sep 2021 14:07:07 +0100
Message-Id: <cover.1631192734.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add some infra to test exec(), hopefully we will get more
tests using it. And also add a timeout test, which uses exec.

Pavel Begunkov (2):
  tests: add no-op executable for exec
  tests: test timeout cancellation fails links

 .gitignore         |  1 +
 test/Makefile      |  2 ++
 test/exec-target.c |  4 +++
 test/timeout.c     | 84 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+)
 create mode 100644 test/exec-target.c

-- 
2.33.0

