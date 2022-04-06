Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1199F4F6DED
	for <lists+io-uring@lfdr.de>; Thu,  7 Apr 2022 00:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237237AbiDFWnu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Apr 2022 18:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237167AbiDFWnj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Apr 2022 18:43:39 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E2FDE908
        for <io-uring@vger.kernel.org>; Wed,  6 Apr 2022 15:41:39 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id b15so3805585pfm.5
        for <io-uring@vger.kernel.org>; Wed, 06 Apr 2022 15:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=R93xP7tO35PFBvfj3CpxpHpHaRdOFepTciyjhwYRnC4=;
        b=KYT0vGo7C5lugAwEerKSmHvWvz9zruQHKfs+VgqKcZEAxE5NUPhiqVmvTMY4XpyTqA
         KzAxkhGeNK6grMuzIdMQNB306lMI+bz5gy23aoab+VRfmIXa7gbZJc3cJcXWqPckXgSZ
         lpVAEmN1SdMZQDvDjBdtb2+L07fjh6Mp0ORhcgzc1oeGVm0DmfE8E9rXZtKDbOPly4R8
         yV2u1EYK1E8NWck3H95ji77Qg37QXQfDKWPmKH307xT/zEWSCITrH3PyLrJb/0oiIol8
         93vRVybdLJe04w7VQS0DHXkBTVycSQm3FmvJjnaSgAkGBOzeDjd9IGdYUslHWc1G+KCU
         HkQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=R93xP7tO35PFBvfj3CpxpHpHaRdOFepTciyjhwYRnC4=;
        b=avTNzjyR9u72Ed5+WzEAK192ZKFq5eWlgQw4D1wkaF+5LfExQhgDVExZLkgQlCvgJl
         MYIeDrqBAPUHq4plK0Hn200GUDtNORH8CY+VQbOtCBC2Q4RFKC5lA5i7AgJ5zMwivKlZ
         +PUY8S8z+0enyixiTWh8dQQiMR8Y3kQqLVfI5cqiR9X0NjNM9qLXLq4gMibTdQTNYeMF
         JAoH4AK8sAKzfao8rFGRDx2LjJI/6x01nxuC3xtYHhufrsVuEAUUnpwNULXuoPP0D8FK
         Ksmdzx2iHgYElopDWBXqViGfXGEE/I/3EPqG3AEDm5jHR1+u4EAZAU8etK5JTxnNyjIU
         A3cg==
X-Gm-Message-State: AOAM533KxQ/QhvXcKoAxD7xSq87Aawwpgq1bjnpbFC8xbUGh9k6y2CWH
        n9Q+6MHMXh4AodzBXTS+RT68AOsIfP8yzQ==
X-Google-Smtp-Source: ABdhPJzfRS+9GngQs574q7lBxF87wpdbqV9zzBiwjMb37U7klXYkTkxKNvgUtA0iWOpwfnPXcq5EEg==
X-Received: by 2002:a05:6a00:198c:b0:4fa:c717:9424 with SMTP id d12-20020a056a00198c00b004fac7179424mr10798899pfl.63.1649284898727;
        Wed, 06 Apr 2022 15:41:38 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h13-20020a056a00170d00b004fb1450229bsm21948884pfc.16.2022.04.06.15.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 15:41:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <9c44ecf6e89d69130a8c4360cce2183ffc5ddd6f.1649277098.git.asml.silence@gmail.com>
References: <9c44ecf6e89d69130a8c4360cce2183ffc5ddd6f.1649277098.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: don't scm-account for non af_unix sockets
Message-Id: <164928489789.13740.14903089053110765479.b4-ty@kernel.dk>
Date:   Wed, 06 Apr 2022 16:41:37 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 6 Apr 2022 21:33:56 +0100, Pavel Begunkov wrote:
> io_uring deals with file reference loops by registering all fixed files
> in the SCM/GC infrastrucure. However, only a small subset of all file
> types can keep long-term references to other files and those that don't
> are not interesting for the garbage collector as they can't be in a
> reference loop. They neither can be directly recycled by GC nor affect
> loop searching.
> 
> [...]

Applied, thanks!

[1/1] io_uring: don't scm-account for non af_unix sockets
      commit: 181440ea22d834719489d2a33289f2834a333687

Best regards,
-- 
Jens Axboe


