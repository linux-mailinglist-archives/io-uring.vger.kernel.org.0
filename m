Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE78505EFE
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 22:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347822AbiDRUzO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 16:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbiDRUzN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 16:55:13 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7D022BD7
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 13:52:33 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id p21so15576593ioj.4
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 13:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=5gbMiRklA3mGcPsHpxBegt+JZYUqcdcqnkzOGBInLM0=;
        b=Zte4T8UDrGhgbuR0ar6WuJ1djBMbDkD4m/c20YDmakvOLUpRvORmFJd82aKYYROhd2
         MmLJNJDPIt+j3qBsSikvztco+S8A+yAjpFXlFSsFEYOlng1cvtypca4hMnWhdmBngztn
         R2GB+EzkkMC9yTB7/ym8B8pzznYXz74E232msCMnCn46+yjt8hJzWhFiN0lSSuD8c4fa
         Z+dcUua2iDRqPj7DrLcshtuiiEKcCzAnYM8gvj2IPL08gdgtWlItnIgfuTTHlcpt/mTQ
         yLUeN7S/uPByAnCjoSvEeZUwm5pfHSwCylJBQ4xhYP0tdxATzPOge8Xp2NbtMYNRV8Iz
         H59g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=5gbMiRklA3mGcPsHpxBegt+JZYUqcdcqnkzOGBInLM0=;
        b=RycwIsxwFZD8i3lhnNviaWxT99HfqQ6SxM0vBLqLdgrLqPxOU9xTofKmuIX/Xz2FEL
         DzgBaLwXqWD9MyDfn2SmuCv3MPCdTY/XmE/NmdtBrKom4M0yMm75sQPG/1S85A1UEq9c
         oNQC1y34adLYBhUMvxnj39CFk7xUxKlWqNsx8K41Ng3ylQFs8dGSdAnJ1+PXWdtHxvx5
         +yaMDnE3vOSxWNKJnl/xBK0XugkyfK39cvMWnY8OFzzKu1A97Gia3ezkys9gbyWvEuhu
         DBAnp2uhDpH8Iv3FNejaMxpEBB17CcwSBtb3z172rcTRn4n/09zGyJnQkhUVRS6f2msX
         ik9A==
X-Gm-Message-State: AOAM532DU4hPWLlHym9T6kAz1Aus1DKvE0DPzrlm3rEVnYyvSKby2dqQ
        WnQEg0zmrURgRMR9tJFo8ldgl6eft6fflA==
X-Google-Smtp-Source: ABdhPJwzG9XzlOdjfiCpGcWVMBeWNsrAVFH5Ybtu2leh6kkY3mP9TGZ7qNsT/w2XAwOMT5S9/B+uKA==
X-Received: by 2002:a05:6638:2405:b0:327:d930:bc9c with SMTP id z5-20020a056638240500b00327d930bc9cmr5964303jat.70.1650315153116;
        Mon, 18 Apr 2022 13:52:33 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r4-20020a924404000000b002c9dc82ab11sm7909654ila.79.2022.04.18.13.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 13:52:32 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <cover.1650311386.git.asml.silence@gmail.com>
References: <cover.1650311386.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/5] random 5.19 patches
Message-Id: <165031515242.148626.17261800284582343473.b4-ty@kernel.dk>
Date:   Mon, 18 Apr 2022 14:52:32 -0600
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

On Mon, 18 Apr 2022 20:51:10 +0100, Pavel Begunkov wrote:
> Resending some leftovers
> 
> Pavel Begunkov (5):
>   io_uring: use right helpers for file assign locking
>   io_uring: refactor io_assign_file error path
>   io_uring: store rsrc node in req instead of refs
>   io_uring: add a helper for putting rsrc nodes
>   io_uring: kill ctx arg from io_req_put_rsrc
> 
> [...]

Applied, thanks!

[1/5] io_uring: use right helpers for file assign locking
      commit: 602b87b4a9cc56c6054b4524a40ecb5b42e9c722
[2/5] io_uring: refactor io_assign_file error path
      commit: 6d51914bcd061b6c25d761470b4bbf1ea4470be9
[3/5] io_uring: store rsrc node in req instead of refs
      commit: bf9bab6e6369c4b3f03a97345bd401925d8b315c
[4/5] io_uring: add a helper for putting rsrc nodes
      commit: 86ec2e629c84f6d57e1ccfc638b6b475aca699a6
[5/5] io_uring: kill ctx arg from io_req_put_rsrc
      commit: 111141d5824e947a9a129393315d8473a9356af4

Best regards,
-- 
Jens Axboe


