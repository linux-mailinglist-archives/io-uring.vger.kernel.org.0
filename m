Return-Path: <io-uring+bounces-9101-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D6E1B2DE25
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 15:44:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 332623AF601
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 13:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F01331DDB4;
	Wed, 20 Aug 2025 13:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zd0xfn8+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D424279354;
	Wed, 20 Aug 2025 13:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755697338; cv=none; b=h1dJOlqUJ0Rs8bxcx/2t1A8DZ6D94spRpjuRIgpZ+TI/xjvt3jcF5Qf8ioEDpme+HA3xDMvgWofeh7ISzt5v2FKQWypMD+klwJjMkdUcLC+rcuBlEkXbnU9MqZFALzZz6uDX42JxcU7IKMTIoCxAytiDgFw4EJ+MECPyb1mP7k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755697338; c=relaxed/simple;
	bh=GwzwwgyfcwqqHuSy6ePWprhgFwNZ7jn3wGiJU2BpbWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mtrVJAZpjylLzrb9xrWIdTj8Tw0FAsbuIV/jKDOoao7O87e1T+4/wevlmW8sgLiYa/eCNH+14MRcBk6eeWUFVzr7+Y1pde+3O1hPLs4figXMAcuWoAaUzPojL5ZdpAZHNEb1CoyuokycZr7VR+40m7GakPB3rkU1IVYcX8FZOYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zd0xfn8+; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45a1b004a31so45025515e9.0;
        Wed, 20 Aug 2025 06:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755697335; x=1756302135; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D//IkqSgYiDNhWtOIHFgRl44HO3wESqHykekTe6D+/U=;
        b=Zd0xfn8+9QqQlABfg85uqQ2DpDP1wCo4aQzHoPCa/lFiSbSGJU0Kg01iXqimJ3yaiJ
         sAGDXdJjCplmTtGsI+K3HU2TWf7XWrn1BYLqLwh4eljHOiBETgDDtfof4oNoKGEOvqn5
         AdIblZJhp8x/ii//9+lwKa7FYkCZgZ3oBzEdo0d4q66Va84hS8tBpENRIlL9YHNN1qDJ
         VxDFZNEPc53/l7DfCAne1ioyFbu7YySFsJo7+9+Mortz0t/Ia9VhVcYshqTaaJ0emHYG
         oTPYa+yNluMgzTvJ6Z6xecmqBHGrVMykvPvrbWpWi91v88qs0Su007nIlqB3Xe1dHQMI
         MsWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755697335; x=1756302135;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D//IkqSgYiDNhWtOIHFgRl44HO3wESqHykekTe6D+/U=;
        b=ML1Dr8YfKUgox2PuGyO59tujG/K74r0QKQY3swcHjl2ANA5YBycbBNQkGdXwuPU8Zk
         neJjHBcrG8lyzDbGmCY/ihOQpJbmAxZrusU7qcJBXsK9hbzarNRLv87uyOtcj0vFmx8Z
         2WtDHZX0s3sQjQ0WSavg7fP5GiEllJmt0Yxuk23A7fooU3GYccB01mEaHub94QlF4ZZ7
         5Y/OrY2uyTwSZ/nw6ArwJqcTMAnrXokVjiqN6/n4FIXfVtl5yQ4jDoTcnyUDZaxIDZsj
         6Sjmz2pqpMOU4cdYnpT+WPj6l0Duy7qJSZa5DllOOcQc6PidhG20eX54zyQJwH2h/IcO
         31sQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrSu0ySLFC50MBGgj0/DYB7yQ4BdJCHgBCq7IUHGKQldZsTacFJzPdP4Yl53FCeBUbFFf0m16L@vger.kernel.org, AJvYcCVAZruHy0n73tiFBGNFe0D8kokzgseR1M5qIBXUYHkcxXgA9GO24r0x1pnQQHrq2GXl2p5SQriNw+RjEaFZ@vger.kernel.org, AJvYcCWptn4x4iiF145FM4oP+FhB2WyF4s4zl5fDzRfuRuP8iWLW2fE1bbukqKx+JVmlTcNuGd4lAZGCWg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyMcv2eV+Z3JNH+FsnCD10JgVV7CkZTo9CLJEjIZazm2wQal7PF
	HPzkT+xbGbLOiUXx6xYGl23OuKpxpS7A2NUeiky3qWBKp21J1BTSDo8a
X-Gm-Gg: ASbGncvfVjOBqrMtLuJWUFrV3pPVPSHWtueqkq8yDugepVSIYOv4dLCaQfoZb7S5/ho
	W4M3kwEe8IK0MB2RdzmaJvdS77e5Y9PTUjWU3jWCqQRzZeY/ZwZYdgLNEIaXz1xDWmOotr4tZnj
	orckjcAh7rGQRsvlfxAI41IRrPrltvX/q339hkriwhb1xxLmI+padqtBKdCaMnkynqQWp/fzXW2
	mGth3zB7fhGg4ul/hjMl1LStXcDSYSnF8q9o+1Bj8hoTuHKDyXkErSRpLFrSFpIpigWXekGtHBm
	b2rbT+ib/qMXCZioxQrosiqlnnuQYjzVgtDTVHg0+OKEch9JkqtG0Re3O1gNrscpFkd19/IFpdS
	pneCKX4+xCCViPqnyrI88si0Mtad3EUsPmCejn6pEZH8g6w+w1fa1R7KFHkodBjac8w==
X-Google-Smtp-Source: AGHT+IEPrLhd+G8QilOq2hZbXfX8bnPCYF3Vhwwz/ytgqwVqzAjC4BEqxfxFhrefUqHnTGOBgbr9OA==
X-Received: by 2002:a05:600c:4744:b0:45a:236a:23ba with SMTP id 5b1f17b1804b1-45b479e4b91mr18847345e9.22.1755697334538;
        Wed, 20 Aug 2025 06:42:14 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:5f7e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c3c85efc57sm1815616f8f.40.2025.08.20.06.42.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 06:42:13 -0700 (PDT)
Message-ID: <55e8116d-7bff-4116-a5cf-d96cf95e02d8@gmail.com>
Date: Wed, 20 Aug 2025 14:43:25 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 07/23] eth: bnxt: read the page size from the
 adapter struct
To: Mina Almasry <almasrymina@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>,
 Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org,
 davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk,
 michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <cover.1755499375.git.asml.silence@gmail.com>
 <43a256bdc70e9a0201f25e60305516aed6b1e97c.1755499376.git.asml.silence@gmail.com>
 <CAHS8izNq8wKXwiZs8SeuYhsknR=wAwWPEnBOxUgcMhCoObQ=xA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izNq8wKXwiZs8SeuYhsknR=wAwWPEnBOxUgcMhCoObQ=xA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/19/25 20:37, Mina Almasry wrote:
> On Mon, Aug 18, 2025 at 6:56 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> From: Jakub Kicinski <kuba@kernel.org>
>>
>> Switch from using a constant to storing the BNXT_RX_PAGE_SIZE
>> inside struct bnxt. This will allow configuring the page size
>> at runtime in subsequent patches.
>>
>> The MSS size calculation for older chip continues to use the constant.
>> I'm intending to support the configuration only on more recent HW,
>> looks like on older chips setting this per queue won't work,
>> and that's the ultimate goal.
>>
>> This patch should not change the current behavior as value
>> read from the struct will always be BNXT_RX_PAGE_SIZE at this stage.
>>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> Reviewed-by: Mina Almasry <almasrymina@google.com>
> 
> nit: AFAIU BNXT_RX_PAGE_SIZE should be unused after this? You could
> delete the definition in bnxt.h if so.

Still used in a couple of places, notably as the minimum and/or
default size

-- 
Pavel Begunkov


