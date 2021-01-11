Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30AD92F0C3F
	for <lists+io-uring@lfdr.de>; Mon, 11 Jan 2021 06:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbhAKFYL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jan 2021 00:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbhAKFYK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jan 2021 00:24:10 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF84C061786
        for <io-uring@vger.kernel.org>; Sun, 10 Jan 2021 21:23:30 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id t30so15052599wrb.0
        for <io-uring@vger.kernel.org>; Sun, 10 Jan 2021 21:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WfKvOqoIQHIS9+tDlH8Ku/AZv1yv6HKg3EV+OPk+uO0=;
        b=XaQmi1129H2hBXf66nnkS7AwOBMS0gPrvy3gzZy/GMnWGaWg2NbFmCONre95JWuMND
         s6wuG/jCIW93PJDS7/zkhVb9v20v4fpowTtRAtLmybcBvVv6vIiYOeAPNyqC6wDIJt3X
         klFAYkaNv0Ps0nbFbPazATEgBq25nlHqayuTxIiFEpvel5N9ehnWP9fsAn5bWHOxG9X3
         K2MMsHfbxfsnm/j27sh6TJDtW2VBm0/hYiRTeVvaXph99p7e2Imm66BpFZiNAWOgU9OS
         zeAbA3o5qCefKESKTukvFM2D6fjlbdgGXa+kL+jWdTbV7yLYgnPiIcltMDXDLJP9ghf+
         eYNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WfKvOqoIQHIS9+tDlH8Ku/AZv1yv6HKg3EV+OPk+uO0=;
        b=emc56JWNWIa8EbUWJI3B+j1o1rE0WCsVY0yZwqZgkSrQFol5pr1sIJL6QcoDur0tAY
         ZLVUEt3hOcmQeL6yBbg8l3pg1OvF2dazFnDZVURx3KiOpD3njyQP0ghkEB8+0jfQmOl6
         u5Ez41ymof4dTmFW6NQOLGpfVndrLg6iUZrAtCsejepdgcYQWefAhM2k7FW9uA/FtLrO
         /bhipVH7ryweGpquwMHkqpQQ8Hs6WoBKkLVpherpLL69ErE6CLJH9Xnh4ydm8lbBAGz2
         Entws5cbDjtJglC1ZQ94Kb6yY9sHLMgURVu9FBPMB9XWQAN/NlAcGtTZRGsFlqaWEXeg
         BHfw==
X-Gm-Message-State: AOAM533aDg7GQytS4/FNiR7ftshDp9kKlCROJAX+qKEvDI0RJgn6Diiu
        ZLMQOjHBHt0n5erm07UA4tb2UnOXYOY=
X-Google-Smtp-Source: ABdhPJz8FWBnpoWKold9or/lW6w6xQYv9NFmzcNgh1oqgmncb98wUwHEXPpxaQGtNSNwp6IlsqHPKw==
X-Received: by 2002:adf:9cca:: with SMTP id h10mr14480553wre.77.1610342608988;
        Sun, 10 Jan 2021 21:23:28 -0800 (PST)
Received: from [192.168.8.119] ([85.255.237.6])
        by smtp.gmail.com with ESMTPSA id z15sm23177353wrv.67.2021.01.10.21.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jan 2021 21:23:28 -0800 (PST)
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1607379352-68109-14-git-send-email-bijan.mottahedeh@oracle.com>
 <ff17d576-27eb-9008-d858-e1ebb7c93dad@gmail.com>
 <2070b1b5-2931-7782-305f-c578b3b24567@oracle.com>
 <074644d5-f299-3b70-9d86-bf4ed59d9674@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2 13/13] io_uring: support buffer registration sharing
Message-ID: <4c9d62d8-efc5-1cd6-e73c-9efd3b694950@gmail.com>
Date:   Mon, 11 Jan 2021 05:19:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <074644d5-f299-3b70-9d86-bf4ed59d9674@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> The intended use case for buffer registration is:
> 
> - a group of processes attach a shmem segment
> - one process registers the buffers in the shmem segment and shares it
> - other processes attach that registration
> 
> For this case, it seems that there is really no need to wait for the attached processes to get rid of the their references since the shmem segment (and thus the registered buffers) will persist anyway until the last attached process goes away.  So the last unregister could quiesce all references and get rid of the shared buf_data.
> 
> I'm not sure how useful the non-shmem use case would be anyway.
> 
> Would it makes sense to restrict the scope of this feature?

I have to say I like that generic resources thing, makes it easier to
extend in the future. e.g. pre-allocating dma mappings, structs like
bios, etc.

I didn't think it through properly but it also looks that with refnodes
it would be much easier to do sharing in the end, if not possible
vs impossible.

-- 
Pavel Begunkov
