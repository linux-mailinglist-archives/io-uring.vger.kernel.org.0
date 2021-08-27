Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2193FA00C
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 21:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhH0TgM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 15:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbhH0TgI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 15:36:08 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E44CC061757
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 12:35:19 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id e16so6090870pfc.6
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 12:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Elex4i1WcxElY7cgqtUW+IzQXsbn9+0b0+WHR41TwdU=;
        b=eT60J8KRyF/aLYGB2kP3fnGTbe4/fL/rxWIfXoCVb4gky4NY8BWKjkCLRNbFQNJjhT
         TuBUDmA2Rd67S+KWp7uu1gLhPRwhGOuGDDeyqJIp250Hk86Cqmc/bk9uH2F4OZi/5qMy
         g/giM8JAMj7Nm7kcsIMX+IM1bWDEgGtBDrcpVtAklI+hvAK1RAStOA0IoYQD+83JYd5K
         EUrhZUsix3mfoV70kih0bjfErcjwoGdX6RRgG6I9dJBxBijKDxOVgnYcBEHA+z+rREYY
         SP2bbw4TObla3AhUpq9ONNmQKUaBNxgji6VyXQCGAg+nvY0ilgECpem61Nv13K8JhZmg
         jfZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Elex4i1WcxElY7cgqtUW+IzQXsbn9+0b0+WHR41TwdU=;
        b=I1Zx7sI++jF2pxLDqjbsNixTAOlRS0hkyUQZAQyBKyyRwqH/Gu+RvB2ghw5dPutZ6w
         jQv//6dW0Uv3Mno9sMGSK/+Mv3RYDufajC3cSJ/tDs/fIL3yLrTpEDDb9RfTzhjwyHS2
         34pRr4xy6QPFhFPyeYCy/bwHFZROiMXAufpCrwBYDvatQOXo/s4N3E5j//aA2nbtRhA2
         3LRW6/rlJjlIvWstw56BB9kWilqTZuPae/PRKnVe3juQxGf4WvZhobH7b56nV5lfHZGF
         KKG8IccA8s9MGjmf4KDHifuWF6un/PtwhrEEhdDpKYsU763+O4PbWiVL2br8eAd1F0W1
         LmIg==
X-Gm-Message-State: AOAM531bjC0T3urdC5WaQbAuAxxFkrTO5PwJnm65z6ZMCy9/uWq+1k8J
        +KbGM2AnlUritIQEyMVoh5hW+Nix2iy/DztO
X-Google-Smtp-Source: ABdhPJxuGXAxQtpGIketvyVRw+U7S1ynW0SpzEK+K7xsItsayCEGZ9yF1kRu/pL5k/lOCepuviN8rA==
X-Received: by 2002:aa7:850c:0:b0:3e2:edf3:3d09 with SMTP id v12-20020aa7850c000000b003e2edf33d09mr10722121pfn.42.1630092918550;
        Fri, 27 Aug 2021 12:35:18 -0700 (PDT)
Received: from ?IPv6:2600:380:4935:79ff:156e:745c:f627:64cd? ([2600:380:4935:79ff:156e:745c:f627:64cd])
        by smtp.gmail.com with ESMTPSA id t42sm6767298pfg.30.2021.08.27.12.35.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 12:35:18 -0700 (PDT)
Subject: Re: [PATCH liburing v2] register: add tagging and buf update helpers
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <314323bcd6d053f063181d5b900f6d8f6fb3ce6a.1630092701.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ee6cc2ea-0a34-d961-1bc4-e83ae5e3acd0@kernel.dk>
Date:   Fri, 27 Aug 2021 13:35:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <314323bcd6d053f063181d5b900f6d8f6fb3ce6a.1630092701.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/27/21 1:32 PM, Pavel Begunkov wrote:
> Add heplers for rsrc (buffers, files) updates and registration with
> tags.

Applied, thanks.

-- 
Jens Axboe

