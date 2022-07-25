Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC0A58022F
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 17:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbiGYPtM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 11:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbiGYPtG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 11:49:06 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93754DF4C
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 08:49:05 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id z132so9147738iof.0
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 08:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=8yPQb4XNrfZVKm4iIFP5DLzEqI2wwfDDW2+JIK5M1EQ=;
        b=QJVn3zR2z7SR/q9jQQKN8deoi7W87/qOv38s5Ca5yum3D44L7u/hoPkhO1HxjEp/Ba
         x3YlIsxpOTwfvMhSinfTw+xJAPm0D+Ia/ooeS6PQ8UU93GM3O7KCxyuu9AIXYvfMFvv0
         Hr9Qb8FQuxy8x9o7WFPAGABoWtMd7+MWw+E/ZQUEGdd3LbQVIYqyJbRxhvqZ7e5FN0+b
         pkIzEgDMnYFV7UmmfAnWPVzkSBDovrSFjeEcXER5rvCmkecrFVr8W5DY9QvPToOQ+5K0
         Gisljcl5/e923RLz1FqPHq50V2sUp4RppwG2JzAOhKp8Kj0vcSHP2/0ZEji2pvEk6EVU
         YzMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=8yPQb4XNrfZVKm4iIFP5DLzEqI2wwfDDW2+JIK5M1EQ=;
        b=CCylqyNCXxzcm85Ue/rn+uClRB809VudFATx5qY8TKqaivTIk3yZNLlZHHWeLRfnfh
         IZAAC9SilqM+16O5qzb+LjPDA4JnrlCIWHi4Sxj5xMgq2e2qFM4x5pUqVsKpmPr2jpPk
         3ITstIF61s8FZt7Faef95w2hi4JGEgsbxy5LNZpmOdTdrUUEb3jB9uAonQiWUimaldfb
         xIeLSDIQG2pliDeOXg7pQgRmIFZeqz/429CKrX8wBcqBCVSFwUTiAZ1Ij4H52j98IfwV
         jQAuKam9RWufN4i3QryO/V9S9L4TTj3xNp4fI+DyIetiydyguZtlcDiFOzydrIIVUnnC
         cOBg==
X-Gm-Message-State: AJIora9vK05bP5J8WfDjMoce2jOtrn2Fi4UjsBd8WXHl+zrpjygSs7Hv
        VQ665mZm3SJLXfw9J1KEjBzvsMlHr7y60g==
X-Google-Smtp-Source: AGRyM1vpNPnxfpthjw0HffTKbphconp6pY2qD/1WUe/1ljGOFd8Dz/iBedA6lQVKK3KohVy3lYx/Rw==
X-Received: by 2002:a05:6602:2b88:b0:67c:aca7:2f73 with SMTP id r8-20020a0566022b8800b0067caca72f73mr1060428iov.108.1658764144926;
        Mon, 25 Jul 2022 08:49:04 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g1-20020a056602072100b0067ba7abc4cesm6038147iox.50.2022.07.25.08.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 08:49:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <cover.1658742118.git.asml.silence@gmail.com>
References: <cover.1658742118.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/4] io_uring/zc fix and improvements
Message-Id: <165876414435.1092384.12025756909582912011.b4-ty@kernel.dk>
Date:   Mon, 25 Jul 2022 09:49:04 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 25 Jul 2022 10:52:02 +0100, Pavel Begunkov wrote:
> It mainly fixes net/zc memory accounting error handling and then makes
> it more consistent with registered buffers mem accounting.
> 
> Pavel Begunkov (4):
>   io_uring/net: improve io_get_notif_slot types
>   io_uring/net: checks errors of zc mem accounting
>   io_uring/net: make page accounting more consistent
>   io_uring/net: use unsigned for flags
> 
> [...]

Applied, thanks!

[1/4] io_uring/net: improve io_get_notif_slot types
      commit: cb309ae49da7a7c28f0051deea13970291134fac
[2/4] io_uring/net: checks errors of zc mem accounting
      commit: 2e32ba5607ee2b668baa8831dd74f7cc867a1f7e
[3/4] io_uring/net: make page accounting more consistent
      commit: 6a9ce66f4d0872861e0bbc67eee6ce5dca5dd886
[4/4] io_uring/net: use unsigned for flags
      commit: 293402e564a7391f38541c7694e736f5fde20aea

Best regards,
-- 
Jens Axboe


