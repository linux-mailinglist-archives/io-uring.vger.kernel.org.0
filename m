Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33FEF192B59
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2020 15:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgCYOlz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Mar 2020 10:41:55 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45543 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgCYOlz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Mar 2020 10:41:55 -0400
Received: by mail-pf1-f194.google.com with SMTP id j10so1111370pfi.12
        for <io-uring@vger.kernel.org>; Wed, 25 Mar 2020 07:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XCINa/bqSDUlqZD8AeDZCCs9KQApmzJ+EcZpMaMnQiE=;
        b=1y4th5zBJLAPdinDNsQAcPCnP07KOhdoUwWMiLuJy3AnWXSs87PyhBJVRJOWhdDEwM
         VI8UIkGRgodl0kURsdq28TpG4tvJiZYoUpX3sbQ13F2cWFaiMA9zpRByORW/kD3lQmd5
         HCND+yoyVa6cGABwLtFEZ7Xge6/BR6sPuLuV+9r3uHLOJ21imyaxvuqROpeDze2k1GYW
         7XpnLfSi35tZsLpWrqOIbwMeg4VdaeQBkEB2V7HMGkGYiYFfb2S4IAsm4eb6Aw8kj4go
         2n8voRavhgEMowTT4yKTn1nx0TfBmnPNWliyhA9S4UtZBN24HqzMkUalaevIzeIlqLCY
         kp9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XCINa/bqSDUlqZD8AeDZCCs9KQApmzJ+EcZpMaMnQiE=;
        b=jUATSVkpqhXuafvEO5fz3n+2Ye9yr07Hck5RXg4nuIL/eNsBfGGbIi45RQyxGGujN3
         EsAHwjZWQm/GQ82VM2XZC1w3Cq87aBNWOICFbcpd2e3LizyA13D3qamrM2QY1YCjZB3D
         re7O+LWzbxjk7DnS9PPwcPdinmn+owBIRO3DwZZnYojNYAaYXgIWFCa4SAKuC1/lCHNH
         Rv50Nqn6pr5iVyf6lWVvrJoX23zsfTCr2Hkbb4JTqCL4zaLpwWZSAy2I1UKG1G45UK/U
         WtigOqe3+btkH6HiT/twgQPS7XU4VbhZL827A7jrY5JvKm7pz6ZmgMeVn+RY7WJVPGwA
         YG4A==
X-Gm-Message-State: ANhLgQ0f+t0Wx4S6isOmwtTITQEBIzD0zKlAWm3dmbWNNXZENqLgO3g8
        H4xrs3gms0fXw6lGbeX8ytrpLjmMNxYd/w==
X-Google-Smtp-Source: ADFU+vsylQYqAZKy5Es0twsf9ymu9IpbEgQlJ6+DrsNkH7/GdDMgZpHpjf4lMyTBpW2WLfcpVjSULQ==
X-Received: by 2002:a63:2948:: with SMTP id p69mr3644131pgp.238.1585147312228;
        Wed, 25 Mar 2020 07:41:52 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id d3sm18690858pfq.126.2020.03.25.07.41.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 07:41:51 -0700 (PDT)
Subject: Re: [PATCH liburing] Add test/splice to .gitignore
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20200325083321.16826-1-sgarzare@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d2c5888d-0acc-248f-833d-b60f9960a37c@kernel.dk>
Date:   Wed, 25 Mar 2020 08:41:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200325083321.16826-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/25/20 2:33 AM, Stefano Garzarella wrote:
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  .gitignore | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/.gitignore b/.gitignore
> index 9f85a5f..db163b4 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -74,6 +74,7 @@
>  /test/shared-wq
>  /test/short-read
>  /test/socket-rw
> +/test/splice
>  /test/sq-full
>  /test/sq-poll-kthread
>  /test/sq-space_left

Applied, thanks.

-- 
Jens Axboe

