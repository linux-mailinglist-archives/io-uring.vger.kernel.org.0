Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42F332C9B2
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241792AbhCDBKX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451811AbhCDAiK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:38:10 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32673C0613E3
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:37:29 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id t25so17651798pga.2
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3lw4xYsAYM4nNGD3pp839+oyNk5fzKw4o00Jp0gKL3g=;
        b=fpTUmdMLr9O0F3dsWilaKpMfgoq51uCqsvKsJZL/QxMWTCXyFfF34vl4kbMMfNAPay
         CAK/rd0DY8O6YBcqgoimMZcx9A06F/X5y+B7OydM2XSJ0FW1qwxtnQKZwY9GA0atFQkQ
         X21r9I/Oap8fzbiQyC8VMhExGriRMRSUQNQ/G3LznS2id04Kjn5XqKoReIrFIUgDhgb+
         haiM4reKn8wRRAVGiIzIUOsjsPM1nytLzQETrsW6xZPQZG81TaLXeRqAlTsyolJJ8x0m
         ceZQKnrpf+9bgpqqGgg1IoqjJm+W/BH73Mggqtr69H2LwlHh6YL8Un4PCqiH9SxYaa31
         jD5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3lw4xYsAYM4nNGD3pp839+oyNk5fzKw4o00Jp0gKL3g=;
        b=WnO9BH3XVnhf27DC0r1FujM8bsBgXIIK3lDQoAQOg3/ka9s7rZoBn9SA02TpogozbI
         G33p40OXv7aJzZbCV3/T17rC8DpZcWZV5yC/hPN/7m9jdX7TH5DNDTa3WX+ijdSLY/V4
         zZLMuG6WNJ+Y2FLDlbHvnKWXS9Vm7GC1XixErdsaRXVYAcKKMtzzaN6u2Wh6ma+LRkFc
         m8bDbP2V45N5IMqJPb7hvirDl+uCksNJEgSiDFHaEVUwS4Gb+GdbBfMqSFiox6J3CwnM
         HgLZzCtcV8C+4JdIRtwEASe/36ieaDk9HVsWsqbSk9C5NSaAur3MPxyBi8vppJVtdLLW
         k80Q==
X-Gm-Message-State: AOAM532EBIjoSVMKbXaNApptCRZyxMY8lnsv3PeuW5wkTly5R1oEANta
        y0ztvSSVR0kGD7KU9+WoRhnouZH14jmvCxOH
X-Google-Smtp-Source: ABdhPJwMGv3OcuecvAWs+zF2L0Hj4jwyck66kQjBzy0EQ4mvd/le2HXi8XyCGl94ffMOcSh1fbFt7Q==
X-Received: by 2002:a63:4442:: with SMTP id t2mr1309496pgk.23.1614818248751;
        Wed, 03 Mar 2021 16:37:28 -0800 (PST)
Received: from ?IPv6:2600:380:7540:52b5:3f01:150c:3b2:bf47? ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id e10sm8019732pgd.63.2021.03.03.16.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Mar 2021 16:37:28 -0800 (PST)
Subject: Re: [PATCH 1/4] block: introduce a function
 submit_bio_noacct_mq_direct
To:     Mikulas Patocka <mpatocka@redhat.com>,
        JeffleXu <jefflexu@linux.alibaba.com>,
        Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        caspar@linux.alibaba.com, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, hch@lst.de
References: <20210302190551.473015400@debian-a64.vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8424036e-fba9-227e-4173-8f6d05562ee3@kernel.dk>
Date:   Wed, 3 Mar 2021 17:37:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210302190551.473015400@debian-a64.vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/2/21 12:05 PM, Mikulas Patocka wrote:

There seems to be something wrong with how this series is being sent
out. I have 1/4 and 3/4, but both are just attachments.

-- 
Jens Axboe

