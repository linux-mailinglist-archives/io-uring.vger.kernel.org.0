Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC1D3F5FE6
	for <lists+io-uring@lfdr.de>; Tue, 24 Aug 2021 16:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbhHXOKQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Aug 2021 10:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbhHXOKP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Aug 2021 10:10:15 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3011C061757
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 07:09:31 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id b10so14445152ioq.9
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 07:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=cQrJuIRKeEn8GzKsg94QD++Pb2Sz6DzsJ4nAcwMi8d4=;
        b=Er1s/GIkuYu8C+X+93dcTVtFqT2CjvQmHYqN+20wpKutjeDN1BZIM7svdxjhj3iejK
         Tos2oegCBUC4GQIkllcOBUQxZBrWrH2d8B39R97D7311iQ0OViQmd5goL8PqWNqsUvkk
         GicoV65DtfBJ5U2jJRzWG07nMH3S6VLddqDIDYhq/qEA/+faf/hPFPB+l4gc1amEBgZo
         6OxVfyo3mqKG1M6DpgcuLPQ6E/sZbGHLK24nkaWuWrfob1SJoKMDTC9LqZLVSCOc9KW4
         GV3OkalVKmt2FxaAK4L25ZJd2LKG79680DQx4zs82f6NDueshbIfVM945y5klMx1SFwm
         5yoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cQrJuIRKeEn8GzKsg94QD++Pb2Sz6DzsJ4nAcwMi8d4=;
        b=jRarlnOZtRynIqm9IWHVcT7mnPyWM59NGo6esTVbD2BskZmhU8w7cfWp++prZbCu10
         EUKQzSyb6F2+GnSQGtS4tTHmg5qXcYYQD+ssQ2vkDOdM+YFayhyf3O+Qd6OC9y3NNrak
         hJjEgwuIIjoBseRzeWo2TMpHyil+iASYwqQly3zBK1OSgf9Wp0YbN2XMuYzs+UzlJt4H
         NHw75Hqpbs8PB4VnkTqKBcrtSGPPWg/cDQThAlUlaIIhpUWoDrmaaCEJJdhwi2AzWKjM
         XLjuIpJI0nFKsTenAGLPR8Y2cyO43bp2CsZZi4ncLwueYhbK9PqLFLLzhiJWcbJ+qa0N
         hHsg==
X-Gm-Message-State: AOAM5311zKwMsiYxHrkxl2NY2yVQNtE4DdiHrpOQb1LJWvtTVm9DsRV7
        qBwxgCWVLcMiwWQ3gNBqTFrgaKvybJGl8Q==
X-Google-Smtp-Source: ABdhPJyip8gHc1rtXVUT6XmNGbzUkngefbz7oEfZxZgOA+tMG6X3YJH9AWrRpIt1YjEAmN7k3NbmAQ==
X-Received: by 2002:a5d:8506:: with SMTP id q6mr31066387ion.53.1629814171203;
        Tue, 24 Aug 2021 07:09:31 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id q10sm10272175ion.3.2021.08.24.07.09.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 07:09:30 -0700 (PDT)
Subject: Re: [PATCH liburing 0/2] non-privileged tests
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1629805109.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <51f1eb51-7ea9-e20c-7a91-7cc8197bb0f0@kernel.dk>
Date:   Tue, 24 Aug 2021 08:09:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1629805109.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/24/21 5:39 AM, Pavel Begunkov wrote:
> Two more fixes making it work (partially) with non-privileged users.
> 
> Pavel Begunkov (2):
>   tests: non-privileged defer test
>   tests: non-privileged io_uring_enter
> 
>  test/defer.c          | 39 +++++++++++++++++++--------------------
>  test/io_uring_enter.c |  3 +++
>  2 files changed, 22 insertions(+), 20 deletions(-)

Applied, thanks.

-- 
Jens Axboe

