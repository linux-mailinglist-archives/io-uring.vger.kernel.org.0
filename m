Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882FB45AC30
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 20:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhKWT1y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 14:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbhKWT1y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 14:27:54 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9ABC061574
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 11:24:45 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id x10so29409777ioj.9
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 11:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=Rep4yn5Cke3l0XS16ld3ErwuI+JoWpq3Hjp/1rgEZdI=;
        b=kPqWw9XbIyc1DlRrjraFYdM4EVRR/HZ9hQ6HXgHhsCiW6RwW0DR9qP0Jj9lPTMggc/
         yYWdwZOTksAuPPy74g3u9eqX76+7m5EV0UrC1tbS8qlRADcoYxGq9OtYojtrtLdrF0U3
         en9dRn6QPWSDSTU2qZjZ0H/u9OpGP1ZcfCR6rNAn5ot6nI6qf0AkA4xNe3M6qSuxC5Sm
         Ko/NR8NeX0cT7Q5KVJgtMuF9ERDwDctTUJV9TpARPtNRSsGhn+4jH/45yEiD0H82k2mQ
         f5ETPiy3jKF8Yt1ZQIF70aw7q9YprU1ZDV5HzhKKYU0RnGw504p3HWxKZe+CS0pZ0J3F
         MuTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Rep4yn5Cke3l0XS16ld3ErwuI+JoWpq3Hjp/1rgEZdI=;
        b=OKX+T8U7MskQ8ALy4NaBId8t9tEeTu/d7kiTv0rS6Dlr8CJg0jH8YpIdh0faL54DmN
         6mur+gsmPJ0qzd9BOhmgsk4fUcmZ1+zFDBLex1HhaE8SOI1tgpvU0Jzjf7Zrt0MzdhXp
         ETGQTSJkfwqcvylaBL6oWqravUV5Y9aRK8vh9E9vKjlZ248xIUQ9koNe5W5cwu6y/l/j
         U/+ytMUCl2ovQizkdz56KIberAI5eqclowJTZqDgmGeEM+uvHRk8Q/LE4N8pdHPccmfC
         ymb2mQYMonOUC5CaZI+gJArpQ3pUff/ayCDtoE03+GF8g1+ocSHPXst0LNp9OE5JISIL
         PGJg==
X-Gm-Message-State: AOAM530wjhVbOcq2pSgTQgzH7wKrYOx42+aJaurwsocd/uZmnwzm7dSU
        Xqo6tikdGN40TU5eBnH2nDH0TFNqr6NNBn+8
X-Google-Smtp-Source: ABdhPJyggCpBp+wJ8Cf8wGp/Hp7OQd/nUbV1w8gHzLRsjDLvcPiUjtNIc62UrptWAQrfo3viccE6Xg==
X-Received: by 2002:a02:a91a:: with SMTP id n26mr8995626jam.46.1637695483784;
        Tue, 23 Nov 2021 11:24:43 -0800 (PST)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r14sm9661474iov.14.2021.11.23.11.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 11:24:43 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1637524285.git.asml.silence@gmail.com>
References: <cover.1637524285.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/4] for-next cleanups
Message-Id: <163769548331.431007.6331766063621850074.b4-ty@kernel.dk>
Date:   Tue, 23 Nov 2021 12:24:43 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 23 Nov 2021 00:07:45 +0000, Pavel Begunkov wrote:
> random 5.17 cleanups
> 
> Pavel Begunkov (4):
>   io_uring: simplify reissue in kiocb_done
>   io_uring: improve send/recv error handling
>   io_uring: clean __io_import_iovec()
>   io_uring: improve argument types of kiocb_done()
> 
> [...]

Applied, thanks!

[1/4] io_uring: simplify reissue in kiocb_done
      commit: 06bdea20c1076471f7ab7d3ad7f35cbcbd59a8e3
[2/4] io_uring: improve send/recv error handling
      commit: 7297ce3d59449de49d3c9e1f64ae25488750a1fc
[3/4] io_uring: clean __io_import_iovec()
      commit: f3251183b298912e09297cb22614361c63122e82
[4/4] io_uring: improve argument types of kiocb_done()
      commit: 2ea537ca02b12e6e03dfcac82013ff289a75eed8

Best regards,
-- 
Jens Axboe


