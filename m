Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325FD5094AC
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 03:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383652AbiDUBmh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 21:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383654AbiDUBm3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 21:42:29 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AF51573F
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 18:39:41 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c23so3462483plo.0
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 18:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BTbVNP+QKZCdArpjozBgP7Zt36vem4yyR655aC44kN0=;
        b=qJepCD9R2ucmsJ79KQMHr2gGTD8LvZbk9oMr3qnCxS7I5MDFe9oTrgdq3ivpl/wZnZ
         KVER11/x7j55E3UNlgW8kxKrqI4gBIqSFowNOImnn2DM20V8/wyM61KzBstrNoJVgrSy
         8kqbtn8JnvvYKg8cZuAIAxz9hukIXwFccd5yLfeGPr6DF0RSjh2SFYRU09zepCFNPpqY
         tYTLikAgnUnX2aj1mq9Gr3iGPToCm/XymFBsqi7BXkrjULHCvjOG90FFiNp8m2dLN/we
         VsGy1l+AFjXv9hgZNo7oB421fqcXIm70by5sXBs/X5OKG06cDTuEC0AtR3ZSwy67O5hZ
         qZWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BTbVNP+QKZCdArpjozBgP7Zt36vem4yyR655aC44kN0=;
        b=rO6wGVI1FzQWslqHFE3ler3EohIdQ19Ugm7QRTOwq9j73kX/fXXgvLpR5AMvNHeu3n
         AzGg62NUl7WU8sL4Gi4ire2bJlzkwzojmQQyqFAXG2u73O48epvjqdNWLh4OCreu15BZ
         9typWdqNgZHcYF1g1gxwto5inGYqHhop26Oion2noVf123EhlCYVhF/JvEI4JHbVwI+g
         WCEfU1rhzwObNnFlu4awo7H9voSmDITCytFHkbBzsxBvA4S7JccgEWSWj1Htk26pRWfa
         DHoIg0oYmOOoqUdb6lti44klMDeegdxny51gsD207iC/z9N0ylQ+JxAVGb2GOdhJ/UQf
         kQ9w==
X-Gm-Message-State: AOAM530FHiIZBif4RXYvrW8SI9bK0Bhzh6V/tEQZaUzBj2tRZJVtw401
        tQZoND8vkXsK/WObJ+l0cHbFpcwqvtkS8uJO
X-Google-Smtp-Source: ABdhPJykm9BV5XYvM/zIlS4LuveRFyaEb1E3iuQxDqSFHLJN3tK718wTrn9sgheRVpPoyofsv4W5lQ==
X-Received: by 2002:a17:90b:380e:b0:1d3:248:2161 with SMTP id mq14-20020a17090b380e00b001d302482161mr7013029pjb.228.1650505180485;
        Wed, 20 Apr 2022 18:39:40 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x16-20020a17090ab01000b001cd4989ff4bsm460115pjq.18.2022.04.20.18.39.39
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 18:39:40 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET next 0/2] Allow MSG_WAITALL for send/sendmsg
Date:   Wed, 20 Apr 2022 19:39:35 -0600
Message-Id: <20220421013937.697501-1-axboe@kernel.dk>
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

Just like we did for recv/recvmsg, allow MSG_WAITALL to mean that we want
to wait for all the requested data instead of doing a partial completion.

Patch 2 ensures that we can sanely use apoll multiple times, as long as
we're making progress on the IO. This is important to avoid punting to
io-wq if we can avoid it. The gate on already having polled is lifted
if we did transfer some data, which should avoid the initial worry of
why that place was in check - repeatedly non-block retrying and getting
-EAGAIN.

-- 
Jens Axboe


