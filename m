Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6CF40D171
	for <lists+io-uring@lfdr.de>; Thu, 16 Sep 2021 03:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhIPByv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 21:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhIPByt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 21:54:49 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3672AC061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 18:53:28 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id h9so5048735ile.6
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 18:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LC5a2GnQ9uaCPc/l5dQILT5/YZNeLEHMy0S8RuKKru4=;
        b=IhwRDtk+JubrOPWHFjR9vxzGoW9dJLvc6NLGfWKYmt+x/J3oqQ1NV48NrWPyGUPT8/
         aHjZX6wc2nCmhTvNa5q/FA0+8M6p+zVU+WZYvG3oASEcInRcfoFEz9yi+kPKtl4ZlDjs
         kwUZanZZ/5vZcOjMBCGMX9xACtsV1ovpHtSkIJDGrdsvhsSa5BWlERNmkve7mg2J12Ey
         mHQ9jAKQiOhWyvVdXBJgPsGOwX2L1jNSzCrlfEM6lAm5uY3X6EdOEsZOFBQhdUQrCslh
         dmHK//hSTpkwsSGTC55/6x2NGaidzq5BL5i/HwEXu9NbJi5+kjTnsTYRuD46x6ocXItw
         WPAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LC5a2GnQ9uaCPc/l5dQILT5/YZNeLEHMy0S8RuKKru4=;
        b=V++1SIZAd1z6K61mheDDaOhaPOE2bN1kvvA2qbjzhtGgfr+PKfQo1KlevL6h14yCJy
         WVXnEk2hfGJsY+b+e7NtwgDRgX3wEg1ym99Rz9/IrDoV4dmRgz5yd6HvHzHR6p9R2sK6
         sXNtO9N/B8DpdqLe84yQ8kBYjIo/+YC8eXguAAwn83W7vzgsNTp7MD2qoizM+1YJDCMv
         k7G6O27Om+1wOykjy6IDiSaxU7GTxmRXmamlL2j45z+2eEYILa51bY3+3GT003gOrR2M
         xQP+6YiYaw3DpjJ8lhSvj9Gz+6Lvii+xNbYla6kx48DazH21zp1MPSNG72nsixLTmWYe
         Tc0w==
X-Gm-Message-State: AOAM5315/vgG+fI7pPrEmEPMATkG2V80CDutLO/B9LGSdbiYg8oKMqp4
        PfWYCkRFjWvODpZvrR+bubROF6Mj2PaEzw==
X-Google-Smtp-Source: ABdhPJw+kD4tmf0oCAr1UPZn231D8GN0nwCHJmZY8AC86u2B5dJlTNU5x8Hta/idTHZcL1PaNTnyjA==
X-Received: by 2002:a05:6e02:c88:: with SMTP id b8mr2251409ile.300.1631757207335;
        Wed, 15 Sep 2021 18:53:27 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id t25sm782140ioh.51.2021.09.15.18.53.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 18:53:26 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: remove ctx referencing from
 complete_post
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <60a0e96434c16ab4fe587651448290d61ec9a113.1631703756.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7e8d975a-b145-dcb3-e51c-c0c90eee1a10@kernel.dk>
Date:   Wed, 15 Sep 2021 19:53:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <60a0e96434c16ab4fe587651448290d61ec9a113.1631703756.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/15/21 5:04 AM, Pavel Begunkov wrote:
> Now completions are done from task context, that means that it's either
> the task itself, task_work or io-wq worker. In all those cases the ctx
> will be staying alive by mutexing, explicit referencing or req
> references by iowq. Remove extra ctx pinning from
> io_req_complete_post().

Applied, thanks.

-- 
Jens Axboe

