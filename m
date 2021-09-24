Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027E9417B72
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 21:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346142AbhIXTHe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 15:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhIXTHe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 15:07:34 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B66C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:06:00 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id v18so4520463edc.11
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k1mGZxO7JWjOmdA4cuVLLnhtuauT4k2xcDDqGWj3Rik=;
        b=d5HjMOFBdsa3aJXKoH2mfL6ktu7LVphiZuhfyMl6C2N23Fw56CY/TaNA58NsT6+ep2
         37Ldf6kkRLoWS6gNFzbcn7HsJcXTOEgZ3W1NkwA2rLtSDuCx1PFRoWdELhZg7nzesmGZ
         7gcVGFy1f1lqq+Z2d3/pwbUUhQYhhh9Sag/vqyMOxFcIye/3cGUMvL2cQ+1A8OGZz5nN
         Mp8TDF2Hcv2Mm2Eq++uOqFaXFuYsu/TFhtEVQwm/Dtmn7KzkVfNb94+w63otp2+94+Z9
         G8jQ2GDXG6xOt/aywQWrgjmKduBtBqe6wefMKvOChCTTA+F+7wYvn4Te6r4cMVO5gf2z
         FGhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k1mGZxO7JWjOmdA4cuVLLnhtuauT4k2xcDDqGWj3Rik=;
        b=c3IbTrbEmkwFvUfMz2cTmL0n7zQu/DzLYtnBpw49nMYfvTfaRE9XaRtg1tXID/Y/S2
         s84oCBxD8VKGD9IzPnGmzbSZe9oOOP5zJokb5Ex6uiBm/yu0it7RPVdRqN0LWL1lIjc2
         qneVFtg3oLSztt+0jLHxteM+M2Mp2OcGSqzd/NR2CzY/+hU3f1GcCE3DeXPc0tRsvrJs
         liDxaMRmkpg6k+4fw/WyNnT2TKM8X/0Ii8BTR9Vvz89kj6i1dO6AcnqF7vN7iU5Gb9Oh
         rMwid1HioWlI9qQe0y9pb48A2//0fJNu66xvUMLP+LLBPfXCqbqSrbWDWgCp3FENERlz
         t5nA==
X-Gm-Message-State: AOAM533AH0biGJ9SVkvhNMlwumexkzFACSQj/yB4Ju2SVsoTVhIS4ZBN
        aFx73oGGSkEMBi4/y5jL4Dk=
X-Google-Smtp-Source: ABdhPJxLTMIYiQjT5zW5Ykl33X1/CQmrRhxmQDRelKvrYajH7TUfsQJ5hczRNrRLqf6DL6uwVr/8Bg==
X-Received: by 2002:a50:dace:: with SMTP id s14mr6855785edj.369.1632510359261;
        Fri, 24 Sep 2021 12:05:59 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id m10sm5380301ejx.76.2021.09.24.12.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 12:05:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 0/2] small test improvements
Date:   Fri, 24 Sep 2021 20:05:15 +0100
Message-Id: <cover.1632507515.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

fix types in rsrc_tags test, and make a few adjustments in multicqe_drain

Pavel Begunkov (2):
  tests: improve multicqe_drain
  tests: match kernel and pass fds in s32[]

 test/multicqes_drain.c | 12 ++++++++----
 test/rsrc_tags.c       |  2 +-
 2 files changed, 9 insertions(+), 5 deletions(-)

-- 
2.33.0

