Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF26F50D650
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 02:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238382AbiDYAgI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 Apr 2022 20:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbiDYAgH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 Apr 2022 20:36:07 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A236B50E28
        for <io-uring@vger.kernel.org>; Sun, 24 Apr 2022 17:33:05 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id u7so8089697plg.13
        for <io-uring@vger.kernel.org>; Sun, 24 Apr 2022 17:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Q86C8AwH47IjPaOFgodwqV2gbd1atN/JWCdIhc8bRmk=;
        b=h/ShNirQesAhqSgp4PDxoxDYPW5Z5A1kyEusvdHOuqCfDNk/6mvhccH3CljWpUe0GZ
         I0COzt72cAzWoB0V9tB3XXUKHMXtp3kiOEeSw475opWHFOay/B4AbVOm/vrkeuCC1eB+
         b8VJqW0dqc6brII0hoY6pFXmgYOp8uRjHLQucU4EfFjdAQM0O4JUfR3GsiNj/d5RcJPQ
         4f5ig1THtLAk8DQ1fkAe4kpCFHFl5kDUysShUe1lgKBFM2zHAIvukAo1+G7kW+5t8d/z
         YDZxkiIh7txsamMWu1jsj+3TsIqhWyNE0t8XWjmeZBYcoSRl9nW3vsXXkqUGI/bAJkxJ
         4qOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Q86C8AwH47IjPaOFgodwqV2gbd1atN/JWCdIhc8bRmk=;
        b=EvxmZvvC5HoSl7dN0C+qShYM74s7+gsqKtXic9mL3u+nkZFmm5R+INrx029HmL4Gl3
         59zmUDnFdehdYZIR/1so0Kn6CqXQCRu56tTQF/dDX/uQ3ZlBMPUZ6u3lHg+UgK3bNnDD
         BkFi71xh4loyg9KW3MDT5c98+PEXWbsUGg32QO/oatq91rVhSAq8LaPIKMLMsGrZvaFH
         1c7aRki7dNj+XFuNTsEGCGsaIaAPQ9QtfjMBtoJ7kZc0ObryN3aeZrveU41i19S0eqJB
         0fR+dVADeH67gee4IChW2NRR/MwWseaGlXVGf6+Ciu4jrOqb8LIaooh/ohhP5+nciZuA
         AnGQ==
X-Gm-Message-State: AOAM530yj1Cep+aKRjzpQnzqKSK5yg8s0REsB6+5o2q/r3s2OiITo51o
        9EeIQwnWJx/OG5mWqUHxGb0bdPnQN3jK8z1n
X-Google-Smtp-Source: ABdhPJw5GqvD0W7pJ4X6lyL758uMBIdI/MO2oeSntAnyqKUtUl+Ixqb+Eu6xA76YZnJ1FYgvbyGCqg==
X-Received: by 2002:a17:902:9309:b0:156:983d:2193 with SMTP id bc9-20020a170902930900b00156983d2193mr15423071plb.158.1650846785087;
        Sun, 24 Apr 2022 17:33:05 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b20-20020a62a114000000b0050d231e08ffsm5299638pff.37.2022.04.24.17.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 17:33:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, joshi.k@samsung.com
Cc:     Christoph Hellwig <hch@lst.de>
In-Reply-To: <20220422101048.419942-1-joshi.k@samsung.com>
References: <CGME20220422101608epcas5p22e9c82eb1b3beef6bf6e1c2e83b4b19b@epcas5p2.samsung.com> <20220422101048.419942-1-joshi.k@samsung.com>
Subject: Re: [PATCH] io_uring: cleanup error-handling around io_req_complete
Message-Id: <165084678436.1236498.2151364265856264200.b4-ty@kernel.dk>
Date:   Sun, 24 Apr 2022 18:33:04 -0600
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

On Fri, 22 Apr 2022 15:40:48 +0530, Kanchan Joshi wrote:
> Move common error-handling to io_req_complete, so that various callers
> avoid repeating that. Few callers (io_tee, io_splice) require slightly
> different handling. These are changed to use __io_req_complete instead.
> 
> 

Applied, thanks!

[1/1] io_uring: cleanup error-handling around io_req_complete
      commit: 4ffaa94b9c047fe0e82b1f271554f31f0e2e2867

Best regards,
-- 
Jens Axboe


